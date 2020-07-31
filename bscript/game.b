playerName := "Anonymous";
player := {};

const LIGHT_RADIUS = 15;

const MOVE = 1;
const CONVO = 2;
const TRADE = 3;
const COMBAT = 4;
gameMode := MOVE;
moreText := false;

const CHAR_SHEET = 1;
const INVENTORY = 2;
const EQUIPMENT = 3;
const BUY = 4;
const SELL = 5;
const ACCOMPLISHMENTS = 6;
const HEAL = 7;
viewMode := null;

equipmentPc := null;
equipmentSlot := null;
equipmentSlotItems := [];

const EFFECT_DAMAGE = 0;
effect := null;

convo := {
    "npc": null,
    "map": null,
    "key": null,
    "answers": [],
    "saleItems": [],
};

mapMutation := null;

const HEALING_LIST = [
    { "name": "Minor healing", "price": 10, "action": (self, pc) => gainHp(pc, 10), },
    { "name": "Major healing", "price": 32, "action": (self, pc) => gainHp(pc, 50), },
    { "name": "Absolute healing", "price": 55, "action": (self, pc) => gainHp(pc, pc.level * pc.startHp), },
    { 
        "name": "Resurrection", "price": 128, 
        "action": (self, pc) => { 
            gameMessage(pc.name + " returns to life!", COLOR_GREEN);
            pc.hp := 1; 
            gainHp(pc, pc.level * pc.startHp); 
        }, 
    },
];

def initGame() {
    # init the maps
    events["almoc"] := events_almoc;
    events["bonefell"] := events_bonefell;
    events["redclaw"] := events_redclaw;
    events["redclaw2"] := events_redclaw2;
    events["world1"] := events_world1;
    events["beetlecave"] := events_beetlecave;
    events["fenvel"] := events_fenvel;
    events["untervalt"] := events_untervalt;
    events["ashnar"] := events_ashnar;
    events["ashnar2"] := events_ashnar2;
    events["van"] := events_van;
    events["skyforge"] := events_skyforge;

    initItems();

    savegame := load("savegame.dat");
    if(savegame = null) {
        player := {
            "x": 18,
            "y": 4,
            "map": "bonefell",
            "blockIndex": 0,
            "messages": [],
            "gameState": {},
            "inventory": [],
            "coins": 10,
            "party": [],
            "partyIndex": 0,
        };    

        gameMessage("You awake underground surrounded by damp earth and old bones. Press H any time for help.", COLOR_YELLOW);
        c := newChar(playerName, "fighter1", 1);
        c["index"] := 0;
        player.party[0] := c;

        # for combat testing
        #i := 1;
        #while(i < 4) {
        #    name := choose(["fighter1", "robes2", "robes", "man1", "man2", "woman1", "woman2"]);
        #    c := newChar(name, name, 1);
        #    c["index"] := i;
        #    player.party[len(player.party)] := c;
        #    i := i + 1;
        #}      
    } else {
        player := savegame;
        player.partyIndex := array_find_index(player.party, p => p.hp > 0);
        player.messages := [];
        gameMessage("You continue on your adventure.", COLOR_WHITE);
    }
    player.blockIndex := getBlockIndexByName("fighter1");
    player["image"] := img[blocks[player.blockIndex].img];
    mapName := player.map;
    gameLoadMap(mapName);
}

def gameLoadMap(name) {
    loadMap(name);

    mapMutation := load(name + ".mut");
    if(mapMutation = null) {
        mapMutation := {
            "blocks": {},
            "traders": {},
            "monster": {},
            "loot": {},
            "npcs": {},
        };
    }

    applyGameBlocks(name);
    array_foreach(map.monster, (i, e) => {
        e["image"] := img[blocks[e.block].img];
        e["start"] := [e.pos[0], e.pos[1]];
        e["id"] := "" + e.pos[0] + "," + e.pos[1];
        e["visible"] := false;
        e["monsterTemplate"] := array_find(MONSTERS, m => m.block = blocks[e.block].img);

        if(mapMutation.monster[e.id] != null) {
            e["hp"] := mapMutation.monster[e.id].hp;
            e["pos"] := mapMutation.monster[e.id].pos;
        } else {
            e["hp"] := e.monsterTemplate.startHp;
        }
    });

    # filter out npcs no longer present
    map.npc := array_filter(map.npc, n => mapMutation.npcs[n.name] = null);

    array_foreach(map.npc, (i, e) => {
        e["image"] := img[blocks[e.block].img];
        e["start"] := [e.pos[0], e.pos[1]];

        # init trade
        # todo: refresh this from calendar every so often
        if(events[name] != null) {
            if(events[name]["onTrade"] != null) {
                trade := events[name].onTrade(e);
                if(trade != null) {
                    if(mapMutation.traders[e.name] = null) {
                        mapMutation.traders[e.name] := [];
                    }
                    inv := mapMutation.traders[e.name];
                    # get 8 first-level items (basic potions, etc)
                    while(len(inv) < 8) {
                        inv[len(inv)] := itemInstance(getRandomItem(trade, 1));
                    }
                    # get 8 player level items
                    avgLevel := int(array_reduce(player.party, 0, (sum, pc) => sum + pc.level) / len(player.party));
                    while(len(inv) < 16) {
                        inv[len(inv)] := itemInstance(getRandomItem(trade, avgLevel + 3));
                    }
                }
            }
        }
    });
    saveGame();
}

def renderGame() {
    drawUI();
    initLight();
    if(gameMode = MOVE) {        
        moveNpcs();
    }
    if(viewMode = null) {
        mx := player.x;
        my := player.y;
        if(gameMode = COMBAT) {
            combatRoundInfo := combat.round[combat.roundIndex];
            if(combatRoundInfo.type = "pc") {
                mx := player.x;
                my := player.y;
            } else {
                mx := combatRoundInfo.monster.pos[0];
                my := combatRoundInfo.monster.pos[1];
            }
        }
        array_foreach(map.monster, (i, m) => { m.visible := false; });
        drawViewRadius(mx, my, LIGHT_RADIUS * 2 - 1);
        startCombat();
    }    
}

def initLight() {
    mx := player.x - LIGHT_RADIUS; 
    while(mx <= player.x + LIGHT_RADIUS) {
        my := player.y - LIGHT_RADIUS;
        while(my <= player.y + LIGHT_RADIUS) {
            block := getBlock(mx, my);
            if(player.x = mx && player.y = my) {
                block["light"] := 1;
            } else {
                block["light"] := -1;
            }
            my := my + 1;
        }
        mx := mx + 1;
    }
    findLight(player.x, player.y);
}

def findLight(mx, my) {
    dx := mx - player.x;
    dy := my - player.y;
    if(abs(dx) <= LIGHT_RADIUS && abs(dy) <= LIGHT_RADIUS) {
        block := getBlock(mx, my);
        block.light := 1;
        if(blocks[block.block].light = false) {
            if(getBlock(mx - 1, my).light = -1) {
                findLight(mx - 1, my);
            }
            if(getBlock(mx + 1, my).light = -1) {
                findLight(mx + 1, my);
            }
            if(getBlock(mx, my - 1).light = -1) {
                findLight(mx, my - 1);
            }
            if(getBlock(mx, my + 1).light = -1) {
                findLight(mx, my + 1);
            }
            if(getBlock(mx - 1, my - 1).light = -1) {
                findLight(mx - 1, my - 1);
            }
            if(getBlock(mx + 1, my - 1).light = -1) {
                findLight(mx + 1, my - 1);
            }
            if(getBlock(mx - 1, my + 1).light = -1) {
                findLight(mx - 1, my + 1);
            }
            if(getBlock(mx + 1, my + 1).light = -1) {
                findLight(mx + 1, my + 1);
            }

        }
    }
}

def gameIsBlockVisible(mx, my) {
    block := getBlock(mx, my);
    return block["light"] = 1;
}

def gameDrawViewAt(x, y, mx, my, onScreen) {
    if(onScreen) {
        if(gameMode = COMBAT) {
            # draw the other party members
            array_foreach(player.party, (i, p) => {
                if(mx = p.pos[0] && my = p.pos[1]) {
                    if(p.hp > 0) {
                        drawImage(x, y, p.image, 0);
                    } else {
                        drawImage(x, y, img["bones"], 0);
                    }
                    if(combat.playerControl && i = player.partyIndex) {
                        drawRect(x, y, x + TILE_W - 1, y + TILE_H - 1, COLOR_YELLOW);
                    }
                }
            });
        } else {
            # draw the player only
            if(mx = player.x && my = player.y) {
                drawImage(x, y, player.party[player.partyIndex].image, 0);
            }
        }
        array_foreach(map.npc, (i, e) => {
            if(e.pos[0] = mx && e.pos[1] = my) {
                drawImage(x, y, e.image, 0);
            }
        });
    }
    array_foreach(map.monster, (i, e) => {
        if(e.pos[0] = mx && e.pos[1] = my) {
            if(e.hp > 0) {
                e.visible := true;
            }
            if(onScreen) {
                if(e.hp > 0) {
                    drawImage(x, y, e.image, 0);
                } else {
                    drawImage(x, y, img["blood"], 0);
                }
                if(gameMode = COMBAT && combat.playerControl = false) {
                    if(combat.round[combat.roundIndex].monster.id = e.id) {
                        drawRect(x, y, x + TILE_W - 1, y + TILE_H - 1, COLOR_YELLOW);
                    }
                }
            }
        }
    });
    if(onScreen && effect != null) {
        if(mx = effect.pos[0] && my = effect.pos[1]) {
            drawEffect(x, y, mx, my, effect);
        }
    }
}

def moveNpcs() {
    array_foreach(map.npc, (i, e) => {
        if(random() > 0.5) {
            dx := choose([ 1, -1 ]);
            dy := choose([ 1, -1 ]);
            e.pos[0] := e.pos[0] + dx;
            e.pos[1] := e.pos[1] + dy;
            block := blocks[getBlock(e.pos[0], e.pos[1]).block];
            if(block.blocking || 
                abs(e.pos[0] - e.start[0]) > 5 || 
                abs(e.pos[1] - e.start[1]) > 5 || 
                (e.pos[0] = player.x && e.pos[1] = player.y)
            ) {
                e.pos[0] := e.pos[0] - dx;
                e.pos[1] := e.pos[1] - dy;
            }
        }
    });
}

def removeNpc(name) {
    npc := array_find(map.npc, n => n.name = name);
    npc.pos := [-1, -1];
    # mark them as removed
    mapMutation.npcs[name] := true;
}

def getMapStartPos(nextMapName) {
    m := links[nextMapName];
    k := keys(m);
    i := 0;
    while(i < len(k)) {
        if(m[k[i]] = mapName) {
            pos := split(k[i], ",");
            return [int(pos[0]), int(pos[1])];
        }
        i := i + 1;
    }
    # error
    return null;
}

def applyGameBlocks(newMapName) {
    # apply map block changes (doors, secrets, etc)
    m := mapMutation.blocks;
    if(m != null) {
        k := keys(m);
        i := 0;
        while(i < len(k)) {
            pos := split(k[i], ",");
            setBlock(int(pos[0]), int(pos[1]), m[k[i]], 0);
            i := i + 1;
        }
    }
}

def gameEnterMap() {
    key := "" + player.x + "," + player.y;
    if(links[mapName] != null) {
        s := links[mapName][key];
        if(s != null) {

            if(events[mapName] != null) {
                if(events[mapName]["onTravel"] != null) {
                    if(events[mapName].onTravel(player.x, player.y) = false) {
                        return false;
                    }
                }
            }

            ss := split(s, ",");
            if(len(ss) > 1) {
                gameLoadMap(ss[0]);
                player.map := ss[0];
                player.x := int(ss[1]);
                player.y := int(ss[2]);
            } else {
                pos := getMapStartPos(s);
                gameLoadMap(s);
                player.x := pos[0];
                player.y := pos[1];
                player.map := s;
            }            
            saveGame();
            if(events[mapName] != null) {
                events[mapName].onEnter();
            } else {
                gameMessage("Enter another area.", COLOR_MID_GRAY);
            }
        }
    }
}

def aroundPlayer(fx) {
    dx := -1;
    while(dx <= 1) {
        dy := -1;
        while(dy <= 1) {
            res := fx(player.x + dx, player.y + dy);
            if(res != null) {
                return res;
            }
            dy := dy + 1;
        }
        dx := dx + 1;
    }
    return null;
}

def gameUseDoor() {
    return aroundPlayer((x, y) => {
        block := blocks[getBlock(x, y).block];
        if(block["nextState"] != null) {
            if(events[mapName]["onDoor"] != null) {
                if(events[mapName].onDoor(x, y)) {
                    return true;
                }
            }
            index := getBlockIndexByName(block.nextState);
            setBlock(x, y, index, 0);
            setGameBlock(x, y, index);
            gameMessage("Use a door.", COLOR_MID_GRAY);
            return true;
        } else {
            return null;
        }
    });
}

def gameSearch() {
    gameMessage("Searching...", COLOR_MID_GRAY);
    return aroundPlayer((x, y) => {
        space := getBlockIndexByName("space");
        block := getBlock(x, y).block;
        if(map.secrets["" + x + "," + y] = 1 && block != space) {
            if(events[mapName]["onSecret"] != null) {
                if(events[mapName].onSecret(x, y) = false) {
                    return false;
                }
            }
            setBlock(x, y, space, 0);
            setGameBlock(x, y, space);
            gameMessage("Found a secret door!", COLOR_MID_GRAY);
            return true;
        } else {
            lootIndex := array_find_index(map.loot, e => e.pos[0] = x && e.pos[1] = y);
            if(lootIndex > -1) {
                # make sure we have not seen this before
                key := "" + x + "," + y;
                if(mapMutation.loot[key] = null) {

                    handled := false;
                    if(events[mapName]["onLoot"] != null) {
                        if(events[mapName].onLoot(x, y)) {
                            handled := true;
                        }
                    }

                    if(handled = false) {
                        getLoot(map.loot[lootIndex].level);
                        amount := roll(5, 10) * map.loot[lootIndex].level;
                        player.coins := player.coins + amount;
                        gameMessage("You find " + amount + " coins!", COLOR_GREEN);
                    }
                    mapMutation.loot[key] := lootIndex;
                    saveGame();
                    return true;
                }
            }
            return null;
        }
    });
}

def gameConvo() {
    aroundPlayer((x, y) => {
        n := array_find(map.npc, e => e.pos[0] = x && e.pos[1] = y);
        if(n != null && events[mapName]["onConvo"] != null) {
            convo := events[mapName].onConvo(n);
            if(convo != null) {
                startConvo(n, convo);
                return 1;
            }
        }
        if(n != null) {
            trace("No convo for " + n.name);
        }
        return null;
    });
}

def startConvo(theNpc, theConvoMap) {
    gameMode := CONVO;
    convo.npc := theNpc;
    convo.map := theConvoMap;
    convo.key := "";

    clearGameMessages();
    gameMessage("Talking to " + theNpc.name, COLOR_GREEN);
    showConvoText();
}

def showConvoText() {
    result := {
        "words": "",
        "answers": [],
    };
    text := null;
    viewMode := null;
    if(convo.key = "_heal_") {
        viewMode := HEAL;
        text := "How can I help?";
        initHealList();
    }
    if(convo.key = "_trade_") {
        text := "Do you want to $sell|_sell_ or $buy|_buy_?";
        result.answers[0] := [ "Bye", "bye" ];
    }
    if(convo.key = "_buy_") {
        viewMode := BUY;
        text := "Browse my wares";
        initBuyList();
    }
    if(convo.key = "_sell_") {
        viewMode := SELL;
        text := "What do you want to sell?";
        initSellList();
    }
    if(text = null) {
        text := convo.map[convo.key];
        result.answers[0] := [ "Bye", "bye" ];
    }
    if(typeof(text) = "function") {
        text := text();
    }
    array_foreach(split(text, " "), (i, s) => {
        if(len(result.words) > 0) {
            result.words := result.words + " ";
        }
        if(substr(s, 0, 1) = "$") {
            # remove trailing punctuation
            w := split(s, "[.,!?:;]");
            ss := split(substr(w[0], 1), "\\|");
            if(len(ss) > 1) {
                result.answers[len(result.answers)] := [ ss[0], ss[1] ];
            } else {
                result.answers[len(result.answers)] := [ ss[0], ss[0] ];
            }
            result.words := result.words + "_15_" + ss[0];

            # add the punctuation
            result.words := result.words + substr(s, len(w[0]));
        } else {
            result.words := result.words + s;
        }
    });
    gameMessage(" ", COLOR_MID_GRAY);
    gameMessage(result.words, COLOR_MID_GRAY);
    array_foreach(result.answers, (i, s) => gameMessage("" + (i + 1) + ": " + s[0], COLOR_WHITE));
    convo.answers := result.answers;
}

def setGameState(name, value) {
    player.gameState[name] := value;
    saveGame();
}

def getGameState(name) {
    return player.gameState[name];
}

def setGameBlock(x, y, index) {
    mapMutation.blocks["" + x + "," + y] := index;
    saveGame();
}

def saveGame() {
    array_foreach(map.monster, (i, m) => {
        mapMutation.monster[m.id] := {
            "hp": m.hp,
            "pos": m.pos,
        };
    });
    save("savegame.dat", player);
    save(mapName + ".mut", mapMutation);
}

def endConvo() {
    viewMode := null;
    if(gameMode = CONVO) {
        gameMode := MOVE;
    }
}

def gameInput() {
    if(isKeyDown(KeyH)) {
        while(anyKeyDown()) {}
        showGameHelp();
    }
    if(moreText && isKeyDown(KeySpace)) {
        while(anyKeyDown()) {}
        pageGameMessages();
    }
    if(isKeyDown(KeyEscape)) {
        while(isKeyDown(KeyEscape)) {}
        if(equipmentSlot != null) {
            equipmentSlot := null;
            setEquipmentList();
        } else {
            endConvo();
        }
    }
    if(gameMode = MOVE || (gameMode = COMBAT && combat.playerControl)) {
        apUsed := 0;
        ox := player.x;
        oy := player.y;
        if(viewMode = null) {
            if(isKeyDown(KeyEnter)) {
                while(isKeyDown(KeyEnter)) {
                }
                gameEnterMap();
            }
            if(isKeyDown(KeyT)) {
                while(isKeyDown(KeyT)) {
                }
                gameConvo();
            }
            if(isKeyDown(KeySpace)) {
                while(isKeyDown(KeySpace)) {
                }
                if(gameUseDoor() = null) {
                    if(gameSearch() != true) {
                        gameMessage("You find nothing.", COLOR_MID_GRAY);
                    }
                }
                apUsed := apUsed + 1;
            }
        }
        if(isKeyDown(KeyC)) {
            while(isKeyDown(KeyC)) {
            }
            viewMode := CHAR_SHEET;
        }        
        if(isKeyDown(KeyE)) {
            while(isKeyDown(KeyE)) {
            }
            viewMode := EQUIPMENT;
            setEquipmentList();
        }
        if(isKeyDown(KeyI)) {
            while(isKeyDown(KeyI)) {
            }
            viewMode := INVENTORY;
            initPartyInventoryList();
        }
        if(isKeyDown(KeyA)) {
            while(isKeyDown(KeyA)) {
            }
            viewMode := ACCOMPLISHMENTS;
            initAccomplishmentsList();
        }
        if(gameMode != COMBAT) {
            oldPartyIndex := player.partyIndex;
            if(isKeyDown(Key1)) {
                while(anyKeyDown()) {}
                player.partyIndex := 0;
            }
            if(isKeyDown(Key2) && len(player.party) > 1) {
                while(anyKeyDown()) {}
                player.partyIndex := 1;
            }
            if(isKeyDown(Key3) && len(player.party) > 2) {
                while(anyKeyDown()) {}
                player.partyIndex := 2;
            }
            if(isKeyDown(Key4) && len(player.party) > 3) {
                while(anyKeyDown()) {}
                player.partyIndex := 3;
            }
            if(oldPartyIndex != player.partyIndex && viewMode = EQUIPMENT) {
                setEquipmentList();
            }
        }
        if(isKeyDown(KeyUp)) {
            player.y := player.y - 1;
        }
        if(isKeyDown(KeyDown)) {
            player.y := player.y + 1;
        }
        if(isKeyDown(KeyLeft)) {
            player.x := player.x - 1;
        }
        if(isKeyDown(KeyRight)) {
            player.x := player.x + 1;
        }

        blocked := player.x < 0 || player.y < 0 || player.x >= map.width || player.y >= map.height;
        if(blocked = false) {
            m := array_find(map.monster, e => e.pos[0] = player.x && e.pos[1] = player.y && e.hp > 0);
            blocked := m != null;
            if(m != null && gameMode = COMBAT) {
                apUsed := apUsed + playerAttacks(m);
            }
        }
        if(blocked = false) {
            block := blocks[getBlock(player.x, player.y).block];
            blocked := block.blocking;
        }
        if(blocked) {
            player.x := ox;
            player.y := oy;
        } else {
            # if stepping on an npc, swap places
            n := array_find(map.npc, e => e.pos[0] = player.x && e.pos[1] = player.y);
            if(n != null) {
                n.pos[0] := ox;
                n.pos[1] := oy;
            }

            if(gameMode = COMBAT) {
                # if stepping on another player, swap places
                pc := array_find(player.party, e => e.pos[0] = player.x && e.pos[1] = player.y && e.hp > 0 && e.index != player.partyIndex);
                if(pc != null) {
                    pc.pos[0] := ox;
                    pc.pos[1] := oy;
                }

                # trace("SAVING POS of " + player.partyIndex);
                player.party[player.partyIndex].pos[0] := player.x;
                player.party[player.partyIndex].pos[1] := player.y;
                apUsed := apUsed + 1;
            }
        }

        # do this last, as it can switch players
        if(gameMode = COMBAT && apUsed > 0) {
            combatTurnStep(apUsed);
        }
    }

    if(viewMode != null) {
        listUiInput();
    }

    if(gameMode = CONVO) {
        if(viewMode != null) {
            if(isKeyDown(Key1)) {
                while(anyKeyDown()) {}
                player.partyIndex := 0;
            }
            if(isKeyDown(Key2) && len(player.party) > 1) {
                while(anyKeyDown()) {}
                player.partyIndex := 1;
            }
            if(isKeyDown(Key3) && len(player.party) > 2) {
                while(anyKeyDown()) {}
                player.partyIndex := 2;
            }
            if(isKeyDown(Key4) && len(player.party) > 3) {
                while(anyKeyDown()) {}
                player.partyIndex := 3;
            }
        }

        if(viewMode = null && moreText = false) {
            index := null;
            if(isKeyDown(Key1) || isKeyDown(KeyEscape)) {
                while(anyKeyDown()) {}
                index := 0;
            }
            if(isKeyDown(Key2)) {
                while(anyKeyDown()) {}
                index := 1;
            }
            if(isKeyDown(Key3)) {
                while(anyKeyDown()) {}
                index := 2;
            }
            if(isKeyDown(Key4)) {
                while(anyKeyDown()) {}
                index := 3;
            }
            if(isKeyDown(Key5)) {
                while(anyKeyDown()) {}
                index := 4;
            }
            if(isKeyDown(Key6)) {
                while(anyKeyDown()) {}
                index := 5;
            }
            if(index != null) {
                if(index = 0) {
                    gameMode := MOVE;
                    viewMode := null;
                    gameMessage("Bye.", COLOR_MID_GRAY);
                } else {
                    if(viewMode = null) {
                        if(len(convo.answers) > index) {
                            convo.key := convo.answers[index][1];
                            clearGameMessages();
                            showConvoText();
                        }
                    }
                }
            }
        }
    }
}

def initBuyList() {
    list := array_map(mapMutation.traders[convo.npc.name], item => item.name + " " + "$" + ITEMS_BY_NAME[item.name].price);
    setListUi(list, [ [ KeyEnter, buyItem ] ], "There is nothing to buy");
}

def initHealList() {
    list := array_map(HEALING_LIST, item => item.name + " " + "$" + item.price);
    setListUi(list, [ [ KeyEnter, healPc ] ], "");
}

def healPc(index, selection) {
    spell := HEALING_LIST[index];
    if(player.coins >= spell.price) {
        gameMessage(spell.name + " is cast on " + player.party[player.partyIndex].name + ".", COLOR_MID_GRAY);
        spell.action(player.party[player.partyIndex]);
        player.coins := player.coins - spell.price;
        saveGame();
    } else {
        gameMessage("You don't have enough money to buy that.", COLOR_RED);
    }
}

def buyItem(index, selection) {
    inv := mapMutation.traders[convo.npc.name];
    if(index < len(inv)) {
        item := ITEMS_BY_NAME[inv[index].name];
        if(player.coins >= item.price) {
            gameMessage("You bought " + item.name + " for $" + item.price + ".", COLOR_GREEN);
            player.coins := player.coins - item.price;
            player.inventory[len(player.inventory)] := itemInstance(item);
            del inv[index];
            saveGame();
            initBuyList();
        } else {
            gameMessage("You don't have enough money to buy that.", COLOR_RED);
        }
    } else {
        gameMessage("Invalid choice.", COLOR_MID_GRAY);
    }
}

def initSellList() {
    # only show items the trader is interested in
    convo.saleItems := player.inventory;
    trace("inventory=" + player.inventory);
    if(events[mapName]["onTrade"] != null) {
        trade := events[mapName].onTrade(convo.npc);
        trace("trade=" + trade);
        if(trade != null) {
            convo.saleItems := array_filter(convo.saleItems, item => {
                itemTemplate := ITEMS_BY_NAME[item.name];
                trace("item=" + itemTemplate.name + " type=" + itemTemplate.type);
                return array_find(trade, t => t = itemTemplate.type) != null;
            });            
        }
    }
    trace("items for sale=" + convo.saleItems);
    list := array_map(convo.saleItems, item => item.name + " " + "$" + ITEMS_BY_NAME[item.name].sellPrice);
    setListUi(list, [ [ KeyEnter, sellItem ] ], "You have nothing to sell");
}

def sellItem(index, selection) {
    if(index < len(convo.saleItems)) {
        item := ITEMS_BY_NAME[convo.saleItems[index].name];
        gameMessage("You sold " + item.name + " for $" + item.sellPrice + ".", COLOR_GREEN);
        player.coins := player.coins + item.sellPrice;
        invIndex := array_find_index(player.inventory, inv => inv.name = item.name);
        del player.inventory[invIndex];
        del convo.saleItems[index];
        saveGame();
        initSellList();
    } else {
        gameMessage("Invalid choice.", COLOR_MID_GRAY);
    }
}


def findSpaceAround(mx, my) {
    r := 1;
    while(r < 10) {
        x := -1 * r;
        while(x <= r) {
            y := -1 * r;
            while(y <= r) {
                mapx := mx + x;
                mapy := my + y;
                if(mapx >= 0 && mapy >= 0 && mapx < map.width && mapy < map.height) {
                    block := getBlock(mapx, mapy);
                    blocked := blocks[block.block].blocking;
                    if(blocked = false) {
                        pc := array_find(player.party, p => { 
                            if(p.pos != null) {
                                return p.pos[0] = mapx && p.pos[1] = mapy && p.hp > 0;
                            }
                            return null;
                        });
                        blocked := pc != null;
                    }
                    if(blocked = false) {
                        npc := array_find(map.npc, p => p.pos[0] = mapx && p.pos[1] = mapy);
                        blocked := npc != null;
                    }
                    if(blocked = false) {
                        m := array_find(map.monster, p => p.pos[0] = mapx && p.pos[1] = mapy);
                        blocked := m != null;
                    }
                    if(blocked = false) {
                        return [mapx, mapy];
                    }
                }
                y := y + 1;
            }
            x := x + 1;
        }
        r := r + 1;
    }
    # give up
    return [mx, my];
}

def setEquipmentList() {
    equipmentPc := null;
    equipmentSlot := null;
    pc := player.party[player.partyIndex];
    list := array_map(SLOTS, slot => {
        if(pc.equipment[slot] = null) {
            name := "";
        } else {
            name := pc.equipment[slot].name;
        }
        return slot + ": " + name;
    });
    setListUi(list, [ [ KeyEnter, donEquipment ], [ KeyD, doffEquipment ] ], "");
}

def doffEquipment(index, selection) {
    pc := player.party[player.partyIndex];
    slot := SLOTS[index];
    if(pc.equipment[slot] != null) {
        player.inventory[len(player.inventory)] := pc.equipment[slot];
        pc.equipment[slot] := null;
        calculateArmor(pc);
        saveGame();
        setEquipmentList();
    }
}

def donEquipment(index, selection) {
    equipmentPc := player.party[player.partyIndex];
    equipmentSlot := SLOTS[index];
    equipmentSlotItems := array_filter(player.inventory, i => {
        item := ITEMS_BY_NAME[i.name];
        if(item["slot"] = null) {
            return false;
        }
        if(typeof(item.slot) = "array") {
            return array_find(item.slot, slot => equipmentSlot = slot) != null;
        } else {
            return equipmentSlot = item.slot;
        }
    });
    setListUi(array_map(equipmentSlotItems, item => item.name), [ [ KeyEnter, donItem ] ], "No items for _7_" + equipmentSlot);
}

def donItem(index, selection) {
    if(equipmentPc.equipment[equipmentSlot] != null) {
        player.inventory[len(player.inventory)] := equipmentPc.equipment[equipmentSlot];
    }
    equipmentPc.equipment[equipmentSlot] := equipmentSlotItems[index];
    inventoryIndex := array_find_index(player.inventory, invItem => invItem.name = equipmentSlotItems[index].name);
    del player.inventory[inventoryIndex];
    calculateArmor(equipmentPc);
    saveGame();
    setEquipmentList();    
}

def setMapEffect(mx, my, pos, effectName) {
    now := getTicks();
    effect := {
        "pos": pos,
        "effect": effectName,
        "start": now,
        "ttl": now + 0.2,
    };
    start := getTicks();
    while(getTicks() < effect.ttl) {
        drawView(mx, my);
        updateVideo();
    }
    effect := null;
    drawView(mx, my);
    updateVideo();
}

def drawEffect(x, y, mx, my, effect) {
    duration := effect.ttl - effect.start;
    percent := (getTicks() - effect.start) / duration;
    if(effect.effect = EFFECT_DAMAGE) {
        color := COLOR_RED;
        if(percent > 0.5) {
            color := COLOR_YELLOW;
        }
        if(percent > 0.75) {
            color := COLOR_WHITE;
        }
        drawCircle(x + TILE_W/2, y + TILE_W/2, (TILE_W/2) * percent, color);
    } else {
        trace("Don't know how to draw effect: " + effect.effect);
    }
}

def useItem(index, selection) {
    invItem := player.inventory[index];
    item := ITEMS_BY_NAME[invItem.name];
    if(item["use"] != null) {
        pc := player.party[player.partyIndex];
        gameMessage(pc.name + " uses " + item.name, COLOR_MID_GRAY);
        item.use(pc);
        del player.inventory[index];
        initPartyInventoryList();
    } else {
        gameMessage("You cannot use that item.", COLOR_MID_GRAY);
    }
}

def dropItem(index, selection) {
    gameMessage("You throw away " + player.inventory[index].name, COLOR_MID_GRAY);
    del player.inventory[index];
    initPartyInventoryList();
}

def initPartyInventoryList() {
    list := array_map(player.inventory, item => item.name);
    setListUi(list, [ [ KeyEnter, useItem ], [ KeyD, dropItem ] ], "Inventory is empty");
}

def initAccomplishmentsList() {
    list := [];
    if(getGameState("mark_of_fregnar") != null) {
        list[len(list)] := "- Mark of Fregnar";
        list[len(list)] := "identifies you as";
        list[len(list)] := "Fregnar, aids in";
        list[len(list)] := "combat.";
    }
    if(getGameState("enhanced_heal") != null) {
        list[len(list)] := "- Enhanced Healing";
        list[len(list)] := "your injuries heal";
        list[len(list)] := "faster than normal.";
    }
    setListUi(list, [], "No accomplishments so far");
}
