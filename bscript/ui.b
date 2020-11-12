const MESSAGE_Y = 81;

listUi := {
    "list": [],
    "emptyMessage": "",
    "page": 0,
    "index": 0,
    "onSelect": null,
};

def setListUi(list, onSelect, emptyMessage) {
    listUi.list := list;
    listUi.onSelect := onSelect;
    listUi.page := 0;
    listUi.index := 0;
    listUi.emptyMessage := emptyMessage;
}

def listUiInput() {
    if(listUi.onSelect = null) {
        return 1;
    }

    if(isDownMove() && listUi.index + listUi.page < len(listUi.list) - 1) {
        listUi.index := listUi.index + 1;
        if(listUi.index >= 10) {
            listUi.index := 0;
            listUi.page := listUi.page + 10;
        }
        stepSound();
    }
    if(isUpMove() && listUi.index + listUi.page > 0) {
        listUi.index := listUi.index - 1;
        if(listUi.index < 0) {
            listUi.index := 9;
            listUi.page := listUi.page - 10;
        }
        stepSound();
    }
    if(len(listUi.list) > 0) {
        array_foreach(listUi.onSelect, (i, pair) => {
            if(isKeyPress(pair[0])) {
                actionSound();
                idx := listUi.page + listUi.index;
                fx := pair[1];
                fx(idx, listUi.list[idx]);
                if(idx >= len(listUi.list)) {
                    idx := len(listUi.list) - 1;
                }
                listUi.page := int(idx / 10) * 10;
                listUi.index := idx % 10;
            }
        });
    }
}

def drawListUi(x, y) {
    if(len(listUi.list) = 0) {
        drawColoredText(x, y, COLOR_MID_GRAY, COLOR_BLACK, listUi.emptyMessage);
    } else {
        i := 0;
        while(listUi.page + i < len(listUi.list) && i < 10) {
            fg := COLOR_MID_GRAY;
            bg := COLOR_BLACK;
            if(i = listUi.index) {
                fg := COLOR_YELLOW;
                bg := COLOR_MID_GRAY;
            }
            drawColoredText(x, y + i * 10, fg, bg, listUi.list[listUi.page + i]);
            i := i + 1;
        }
        if(listUi.page > 0) {
            drawLine(x, y - 4, x + 2, y - 6, COLOR_GREEN);
            drawLine(x + 2, y - 6, x + 4, y - 4, COLOR_GREEN);
        }
        if(listUi.page + 10 < len(listUi.list)) {
            drawLine(x, y + 102, x + 2, y + 104, COLOR_GREEN);
            drawLine(x + 2, y + 104, x + 4, y + 102, COLOR_GREEN);
        }
    }
}

def drawColoredText(x, y, fg, bg, text) {
    words := split(text, " ");
    wi := 0;
    xx := 0;
    while(wi < len(words)) {
        color := fg;
        word := words[wi];            
        if(wi > 0) {
            xx := xx + 8;
        }
        parts := split(word, "_");
        if(len(parts) > 1) {
            word := parts[2];
            color := int(parts[1]);
        }
        drawText(x + xx, y, color, COLOR_BLACK, word);
        wi := wi + 1;
        xx := xx + len(word) * 8;
    }
}

def drawPcList(x, y) {
    array_foreach(player.party, (i, p) => {
        color := COLOR_MID_GRAY;
        if(i = player.partyIndex) {
            color := COLOR_YELLOW;
        }
        drawColoredText(x + 2, y + 2 + i * 10, color, COLOR_BLACK, substr(p.name, 0, 9));
        drawColoredText(x + 82, y + 2 + i * 10, color, COLOR_BLACK, "H" + p.hp);
    });
}

def drawHeal() {
    drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "Healing by " + convo.npc.name);
    drawListUi(10, 30);

    pc := player.party[player.partyIndex];
    drawImage(10, 120, pc.image);
    drawText(35, 124, COLOR_WHITE, COLOR_BLACK, "Healing for " + pc.name);

    drawText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    drawText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Enter to buy service");
}

def drawTradeBuy() {
    drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "Inventory of " + convo.npc.name);
    drawListUi(10, 30);
    drawText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    drawText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Enter to buy item");
    drawColoredText(10, 170, COLOR_MID_GRAY, COLOR_BLACK, "Party coins: _1_$" + player.coins);
}

def drawTradeSell() {
    drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "Party Inventory");    
    drawListUi(10, 30);
    drawText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    drawText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Enter to sell item");
    drawColoredText(10, 170, COLOR_MID_GRAY, COLOR_BLACK, "Party coins: _1_$" + player.coins);
}

def descAttack(p) {
    s := "  " + p.dam[0] + "-" + p.dam[1];
    if(p.bonus > 0) {
        s := s + "+" + p.bonus;
        if(p["bonusVs"] != null) {
            s := s + " vs " + p.bonusVs;
        }
    }
    return s;
}

def drawCharSheet() {
    pc := player.party[player.partyIndex];
    drawImage(10, 10, pc.image);
    drawText(35, 14, COLOR_WHITE, COLOR_BLACK, pc.name);

    drawColoredText(10, 30, COLOR_MID_GRAY, COLOR_BLACK, "Level:" + pc.level + " HP:" + pc.hp + "/" + (pc.startHp * pc.level));
    drawColoredText(10, 40, COLOR_MID_GRAY, COLOR_BLACK, "Exp:" + pc.exp);
    drawColoredText(10, 50, COLOR_MID_GRAY, COLOR_BLACK, "Next level:" + getNextLevelExp(pc));
    drawColoredText(10, 60, COLOR_MID_GRAY, COLOR_BLACK, "Hit Bonus:" + getToHitBonus(pc));
    drawColoredText(10, 70, COLOR_MID_GRAY, COLOR_BLACK, "Attack:");
    if(len(pc.attack) > 0) {
        drawColoredText(10, 80, COLOR_MID_GRAY, COLOR_BLACK, descAttack(pc.attack[0]));
    }
    if(len(pc.attack) > 1) {
        drawColoredText(10, 90, COLOR_MID_GRAY, COLOR_BLACK, descAttack(pc.attack[1]));
    }    
    if(pc["ranged"] != null) {
        s := "" + pc.ranged.dam[0] + "-" + pc.ranged.dam[1];
        if(pc.ranged.bonus > 0) {
            s := s + "+" + pc.ranged.bonus;
        }
        drawColoredText(10, 100, COLOR_MID_GRAY, COLOR_BLACK, "Ranged:" + s);
    } else {
        drawColoredText(10, 100, COLOR_MID_GRAY, COLOR_BLACK, "No ranged weapon.");
    }
    drawColoredText(10, 110, COLOR_MID_GRAY, COLOR_BLACK, "Armor:" + pc.armor);
    h := describeHunger(pc);
    t := describeThirst(pc);
    drawColoredText(10, 120, h[1], COLOR_BLACK, "HUN:" + h[0]);
    drawColoredText(10, 130, t[1], COLOR_BLACK, "THR:" + t[0]);
    drawColoredText(10, 140, COLOR_MID_GRAY, COLOR_BLACK, describeStates(pc, true));
    drawColoredText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, describeStates(pc, false));

    drawColoredText(170, 20, COLOR_LIGHT_GRAY, COLOR_BLACK, "Stats:");
    drawColoredText(170, 30, COLOR_MID_GRAY, COLOR_BLACK, "STR:" + pc.str);
    drawColoredText(170, 40, COLOR_MID_GRAY, COLOR_BLACK, "DEX:" + pc.dex);
    drawColoredText(170, 50, COLOR_MID_GRAY, COLOR_BLACK, "SPD:" + pc.speed);
    drawColoredText(170, 60, COLOR_MID_GRAY, COLOR_BLACK, "INT:" + pc.int);
    drawColoredText(170, 70, COLOR_MID_GRAY, COLOR_BLACK, "WIS:" + pc.wis);
    drawColoredText(170, 80, COLOR_MID_GRAY, COLOR_BLACK, "CHR:" + pc.cha);
    drawColoredText(170, 90, COLOR_MID_GRAY, COLOR_BLACK, "LUK:" + pc.luck);

    if(pc.name = player.party[0].name) {
        maxSpellCount := getSpellPoints();
        spellCount := 0;
        spellColor := COLOR_GREEN;
        if(player["spellCount"] != null) {
            spellCount := min(player.spellCount, maxSpellCount);
        }
        if(spellCount / maxSpellCount >= 0.5) {
            spellColor := COLOR_YELLOW;
        }
        if(spellCount / maxSpellCount >= 0.8) {
            spellColor := COLOR_RED;
        }
        drawColoredText(170, 110, spellColor, COLOR_BLACK, "Magic:" + spellCount + "/" + maxSpellCount);
    }

    drawColoredText(230, 20, COLOR_LIGHT_GRAY, COLOR_BLACK, "% Save vs:");
    drawColoredText(230, 30, COLOR_MID_GRAY, COLOR_BLACK, "Poison:" + asPercent(pc.save[STATE_NAME_INDEX[STATE_POISON]]/20));
    drawColoredText(230, 40, COLOR_MID_GRAY, COLOR_BLACK, "Paralz:" + asPercent(pc.save[STATE_NAME_INDEX[STATE_PARALYZE]]/20));
    drawColoredText(230, 50, COLOR_MID_GRAY, COLOR_BLACK, "Curse :" + asPercent(pc.save[STATE_NAME_INDEX[STATE_CURSE]]/20));
    drawColoredText(230, 60, COLOR_MID_GRAY, COLOR_BLACK, "Fear  :" + asPercent(pc.save[STATE_NAME_INDEX[STATE_SCARED]]/20));

    drawColoredText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    drawColoredText(10, 170, COLOR_MID_GRAY, COLOR_BLACK, "1-4 to see other pc");
}

def drawAccomplishments() {
    pc := player.party[player.partyIndex];
    drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "Awards/Skills");
    drawListUi(10, 30);
    drawColoredText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
}

def drawMagic() {
    pc := player.party[player.partyIndex];
    if(spell = null) {
        drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "Magic Spells");
        drawListUi(10, 30);
        drawColoredText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Enter to cast spell");
        drawColoredText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    } else {
        drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "PC to cast spell on");
        drawListUi(10, 30);
        drawColoredText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Enter to cast spell");
        drawColoredText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    }
}

def drawCamp() {
    drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "Camping");
    drawColoredText(10, 30, COLOR_MID_GRAY, COLOR_BLACK, "The party is about to");
    drawColoredText(10, 40, COLOR_MID_GRAY, COLOR_BLACK, "rest for 8 hours.");
    drawImage(70, 60, img["fire"]);
    drawColoredText(10, 90, COLOR_MID_GRAY, COLOR_BLACK, "Eat, drink, tell");
    drawColoredText(10, 100, COLOR_MID_GRAY, COLOR_BLACK, "scary stories and");
    drawColoredText(10, 110, COLOR_MID_GRAY, COLOR_BLACK, "sleep.");
    drawColoredText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Enter to camp");
    drawColoredText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
}

def drawPartyInventory() {
    pc := player.party[player.partyIndex];
    drawImage(10, 10, pc.image);
    drawColoredText(35, 14, COLOR_WHITE, COLOR_BLACK, "Party Inventory for _7_" + pc.name);
    drawListUi(10, 30);
    drawText(10, 140, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    drawText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Enter to use item");
    drawText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "R to drop item");
    drawColoredText(10, 170, COLOR_MID_GRAY, COLOR_BLACK, "1-4 to see other pc");
}

def drawCharEquipment() {
    pc := player.party[player.partyIndex];
    drawImage(10, 10, pc.image);
    drawColoredText(35, 14, COLOR_WHITE, COLOR_BLACK, "Equipment of _7_" + pc.name);
    drawListUi(10, 30);
    if(equipmentSlot = null) {
        drawText(10, 140, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    } else {
        drawText(10, 140, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return");
    }
    drawColoredText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "1-4 to see other pc");
    drawText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Enter - equip");
    if(equipmentSlot = null) {
        drawText(10, 170, COLOR_MID_GRAY, COLOR_BLACK, "R - remove");
    } else {
        drawColoredText(10, 170, COLOR_MID_GRAY, COLOR_BLACK, "For slot: _7_" + equipmentSlot);
    }
}

def drawAPBar() {
    if(combat.playerControl) {
        apColor := COLOR_YELLOW;
    } else {
        apColor := COLOR_DARK_GRAY;
    }
    combatRound := combat.round[combat.roundIndex];
    drawText(7, 12 + TILE_H * MAP_VIEW_H, apColor, COLOR_MID_GRAY, "AP:");
    fillRect(
        30, 
        14 + TILE_H * MAP_VIEW_H, 
        30 + max(0, (combatRound.ap/10))*(TILE_W * MAP_VIEW_W - 30), 
        17 + TILE_H * MAP_VIEW_H, 
        apColor);
    drawText(187, 12 + TILE_H * MAP_VIEW_H, apColor, COLOR_MID_GRAY, combatRound.name);
}

def getUiColor() {
    color := null;
    if(gameMode = CONVO || gameMode = TRADE) {
        color := COLOR_TEAL;
    }
    if(gameMode = COMBAT) {
        color := COLOR_RED;
    }
    return color;
}

def isLargeUi() {
    return viewMode = INVENTORY || viewMode = EQUIPMENT || viewMode = BUY || viewMode = SELL || viewMode = CHAR_SHEET;
}

def drawBezel(sx, sy, ex, ey, darkColor, lightColor, n) {
    range(0, n, 1, i => {
        drawLine(sx - i, sy - i, ex + i, sy - i, lightColor);
        drawLine(sx - i, sy - i, sx - i, ey + i, lightColor);
        drawLine(ex + i, sy - i, ex + i, ey + i, darkColor);
        drawLine(sx - i, ey + i, ex + i, ey + i, darkColor);
    });
}


def drawInput(sx, sy, ex, ey, message, prompt, maxLength) { 
    drawBezel(sx, sy, ex, ey, COLOR_DARK_GRAY, COLOR_LIGHT_GRAY, 3);
    drawRect(sx - 3, sy - 3, ex + 3, ey + 3, COLOR_BLACK);
    fillRect(sx, sy, ex, ey, COLOR_MID_GRAY);
    drawBezel(sx + 6, sy + 6, ex - 6, ey - 6, COLOR_LIGHT_GRAY, COLOR_DARK_GRAY, 3);
    s := "";

    fillRect(sx + 7, sy + 7, ex - 6, ey - 6, COLOR_BLACK);
    drawText(sx + 12, sy + 12, COLOR_WHITE, COLOR_BLACK, message);
    drawText(sx + 12, sy + 22, COLOR_WHITE, COLOR_BLACK, prompt + s + "_");
    updateVideo();

    while(true) {
        char := textInput();
        if(char = null) {
            return s;
        } else {
            if(char = "backspace") {
                if(len(s) > 0) {
                    s := substr(s, 0, len(s) - 1);
                }
            } else {
                if(char = "escape") {
                    return "";
                } else {
                    if(len(s) < maxLength) {
                        s := s + char;
                        changed := true;
                    }
                }
            }
        }
        fillRect(sx + 7, sy + 7, ex - 6, ey - 6, COLOR_BLACK);
        drawText(sx + 12, sy + 12, COLOR_WHITE, COLOR_BLACK, message);
        drawText(sx + 12, sy + 22, COLOR_WHITE, COLOR_BLACK, prompt + s + "_");
        updateVideo();
    }
}

def drawMapBorder() {
    drawBezel(4, 5, 5 + TILE_W * MAP_VIEW_W, 5 + TILE_H * MAP_VIEW_H, COLOR_LIGHT_GRAY, COLOR_DARK_GRAY, 2);
}

def drawUI() {
    clearVideo();
    fillRect(0, 0, 320, 5, COLOR_MID_GRAY);
    fillRect(0, 183, 320, 200, COLOR_MID_GRAY);
    fillRect(0, 0, 3, 200, COLOR_MID_GRAY);
    fillRect(317, 0, 320, 200, COLOR_MID_GRAY);

    if(isLargeUi()) {
        drawBezel(4, 5, 315, 5 + TILE_H * MAP_VIEW_H, COLOR_LIGHT_GRAY, COLOR_DARK_GRAY, 2);

        x := 10 + TILE_W * MAP_VIEW_W;
        y := MESSAGE_Y + 50;
        drawRect(x, y, x + (320 - x - 5), y + ((5 + TILE_H * MAP_VIEW_H) - y), COLOR_LIGHT_GRAY); 
        drawGameMessages(x, MESSAGE_Y + 90);        
    } else {
        drawMapBorder();
        fillRect(183, 0, 185, 200, COLOR_MID_GRAY);

        # pc-s
        x := 10 + TILE_W * MAP_VIEW_W;
        y := 5;
        drawBezel(x, y, x + (320 - x - 5), 45, COLOR_LIGHT_GRAY, COLOR_DARK_GRAY, 2);
        drawPcList(x, y);
        fillRect(x - 2, 47, 320, 49, COLOR_MID_GRAY);

        # party info
        y := 50;
        drawBezel(x, y, x + (320 - x - 5), MESSAGE_Y - 5, COLOR_LIGHT_GRAY, COLOR_DARK_GRAY, 2); 
        drawColoredText(x + 5, y + 5, COLOR_MID_GRAY, COLOR_BLACK, "Coins _1_$" + player.coins);
        drawColoredText(x + 5, y + 15, COLOR_MID_GRAY, COLOR_BLACK, calendarString());
        fillRect(x - 2, 78, 320, 80, COLOR_MID_GRAY);

        # messages
        y := MESSAGE_Y;
        drawBezel(x, y, x + (320 - x - 5), y + ((5 + TILE_H * MAP_VIEW_H) - y), COLOR_LIGHT_GRAY, COLOR_DARK_GRAY, 2); 
        color := getUiColor();
        if(color != null) {
            drawRect(x, y, x + (320 - x - 5), y + ((5 + TILE_H * MAP_VIEW_H) - y), color);
        }
        drawGameMessages(x, MESSAGE_Y + 90);
    }

    # show AP
    drawBezel(3, 10 + TILE_H * MAP_VIEW_H, 316, 197, COLOR_DARK_GRAY, COLOR_LIGHT_GRAY, 1);    
    if(gameMode = COMBAT) {
        drawAPBar();
    } else {
        #drawText(7, 12 + TILE_H * MAP_VIEW_H, COLOR_DARK_GRAY, COLOR_MID_GRAY, "You are " + realMapName + ".");
    }


    if(viewMode = HEAL) {
        drawHeal();
    }
    if(viewMode = BUY) {
        drawTradeBuy();
    }
    if(viewMode = SELL) {
        drawTradeSell();
    }
    if(viewMode = CHAR_SHEET) {
        drawCharSheet();
    }
    if(viewMode = INVENTORY) {
        drawPartyInventory();
    }
    if(viewMode = EQUIPMENT) {
        drawCharEquipment();
    }
    if(viewMode = ACCOMPLISHMENTS) {
        drawAccomplishments();
    }
    if(viewMode = MAGIC) {
        drawMagic();
    }
    if(viewMode = CAMP) {
        drawCamp();
    }
}

def showGameHelp() {
    clearGameMessages();
    longMessage := true;
    gameMessage("_1_Arrows or WASD: movement/attack", COLOR_MID_GRAY);
    gameMessage("_1_H: help", COLOR_MID_GRAY);
    gameMessage("_1_C: character sheet", COLOR_MID_GRAY);
    gameMessage("_1_Q: awards and skills", COLOR_MID_GRAY);
    gameMessage("_1_E: change equipment", COLOR_MID_GRAY);
    gameMessage("_1_I: party inventory", COLOR_MID_GRAY);
    gameMessage("_1_T: talk", COLOR_MID_GRAY);
    gameMessage("_1_R: ranged attack in combat", COLOR_MID_GRAY);
    gameMessage("_1_M: cast a magic spell", COLOR_MID_GRAY);
    gameMessage("_1_N: re-cast the last spell", COLOR_MID_GRAY);
    gameMessage("_1_K: camp for 8 hours", COLOR_MID_GRAY);
    gameMessage("_1_Space: search/use door", COLOR_MID_GRAY);
    gameMessage("_1_Enter: use stairs/gate", COLOR_MID_GRAY);
    gameMessage("_1_Numbers: switch pc / option in conversation or trade", COLOR_MID_GRAY);
    longMessage := false;
}
