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

    if(isKeyDown(KeyDown) && listUi.index + listUi.page < len(listUi.list) - 1) {
        listUi.index := listUi.index + 1;
        if(listUi.index >= 10) {
            listUi.index := 0;
            listUi.page := listUi.page + 10;
        }
        stepSound();
    }
    if(isKeyDown(KeyUp) && listUi.index + listUi.page > 0) {
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

def drawPcList(x, y, color) {
    drawRect(x, y, x + (320 - x - 5), 45, color);
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
    drawText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    drawText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Enter to buy service");
}

def drawTradeBuy() {
    drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "Inventory of " + convo.npc.name);
    drawListUi(10, 30);
    drawText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    drawText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Enter to buy item");
}

def drawTradeSell() {
    drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "Party Inventory");    
    drawListUi(10, 30);
    drawText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    drawText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Enter to sell item");
}

def drawCharSheet() {
    pc := player.party[player.partyIndex];
    drawText(10, 10, COLOR_WHITE, COLOR_BLACK, pc.name);

    drawColoredText(10, 20, COLOR_MID_GRAY, COLOR_BLACK, "Level:" + pc.level + " HP:" + pc.hp + "/" + (pc.startHp * pc.level));
    drawColoredText(10, 30, COLOR_MID_GRAY, COLOR_BLACK, "Exp:" + pc.exp + " Nxt:" + getNextLevelExp(pc));
    drawColoredText(10, 40, COLOR_MID_GRAY, COLOR_BLACK, "Hit Bonus:" + getToHitBonus(pc));
    drawColoredText(10, 50, COLOR_MID_GRAY, COLOR_BLACK, "Attack:" + array_join(array_reduce(pc.attack, [], (a, p) => {
        s := "" + p.dam[0] + "-" + p.dam[1];
        if(p.bonus > 0) {
            s := s + "+" + p.bonus;
        }
        a[len(a)] := s;
        return a;
    }), ","));
    if(pc["ranged"] != null) {
        s := "" + pc.ranged.dam[0] + "-" + pc.ranged.dam[1];
        if(pc.ranged.bonus > 0) {
            s := s + "+" + pc.ranged.bonus;
        }
        drawColoredText(10, 60, COLOR_MID_GRAY, COLOR_BLACK, "Ranged:" + s);
    } else {
        drawColoredText(10, 60, COLOR_MID_GRAY, COLOR_BLACK, "No ranged weapon.");
    }
    drawColoredText(10, 70, COLOR_MID_GRAY, COLOR_BLACK, "Armor:" + pc.armor);
    h := describeHunger(pc);
    t := describeThirst(pc);
    drawColoredText(10, 90, h[1], COLOR_BLACK, "HUN:" + h[0]);
    drawColoredText(10, 100, t[1], COLOR_BLACK, "THR:" + t[0]);

    drawColoredText(10, 110, COLOR_MID_GRAY, COLOR_BLACK, "STR:" + pc.str + " DEX:" + pc.dex + " SPD:" + pc.speed);
    drawColoredText(10, 120, COLOR_MID_GRAY, COLOR_BLACK, "INT:" + pc.int + " WIS:" + pc.wis + " CHR:" + pc.cha);
    drawColoredText(10, 130, COLOR_MID_GRAY, COLOR_BLACK, "LUK:" + pc.luck);
    drawColoredText(10, 140, COLOR_MID_GRAY, COLOR_BLACK, describeStates(pc));

    drawColoredText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    drawColoredText(10, 170, COLOR_MID_GRAY, COLOR_BLACK, "1-4 to see other pc");
}

def drawAccomplishments() {
    pc := player.party[player.partyIndex];
    drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "Awards/Skills");
    drawListUi(10, 30);
    drawColoredText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
}

def drawPartyInventory() {
    drawText(10, 10, COLOR_WHITE, COLOR_BLACK, "Party Inventory");
    drawListUi(10, 30);
    drawText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    drawText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "D to drop item");
    drawText(10, 170, COLOR_MID_GRAY, COLOR_BLACK, "Enter to use item");
}

def drawCharEquipment() {
    pc := player.party[player.partyIndex];
    drawColoredText(10, 10, COLOR_WHITE, COLOR_BLACK, "Equipment of _7_" + pc.name);
    drawListUi(10, 30);
    if(equipmentSlot = null) {
        drawText(10, 140, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return to game");
    } else {
        drawText(10, 140, COLOR_MID_GRAY, COLOR_BLACK, "Esc to return");
    }
    drawColoredText(10, 150, COLOR_MID_GRAY, COLOR_BLACK, "1-4 to see other pc");
    drawText(10, 160, COLOR_MID_GRAY, COLOR_BLACK, "Enter - equip");
    if(equipmentSlot = null) {
        drawText(10, 170, COLOR_MID_GRAY, COLOR_BLACK, "D - remove");
    } else {
        drawColoredText(10, 170, COLOR_MID_GRAY, COLOR_BLACK, "For slot: _7_" + equipmentSlot);
    }
}

def drawAPBar() {
    if(combat.playerControl) {
        apColor := COLOR_GREEN;
    } else {
        apColor := COLOR_MID_GRAY;
    }
    combatRound := combat.round[combat.roundIndex];
    drawText(5, 10 + TILE_H * MAP_VIEW_H, apColor, COLOR_BLACK, "AP:");
    fillRect(
        30, 
        12 + TILE_H * MAP_VIEW_H, 
        30 + max(0, (combatRound.ap/10))*(TILE_W * MAP_VIEW_W - 30), 
        15 + TILE_H * MAP_VIEW_H, 
        apColor);
}

def drawUI() {
    clearVideo();

    color := COLOR_DARK_BLUE;
    if(gameMode = CONVO || gameMode = TRADE) {
        color := COLOR_TEAL;
    }
    if(gameMode = COMBAT) {
        color := COLOR_RED;
    }

    drawRect(4, 5, 5 + TILE_W * MAP_VIEW_W, 5 + TILE_H * MAP_VIEW_H, color);

    # pc-s
    x := 10 + TILE_W * MAP_VIEW_W;
    y := 5;
    drawPcList(x, y, color);

    # show AP
    if(gameMode = COMBAT) {
        drawAPBar();
    }

    # party info
    y := 50;
    message_y := 81;
    drawRect(x, y, x + (320 - x - 5), message_y - 5, color); 
    drawColoredText(x + 5, y + 5, COLOR_MID_GRAY, COLOR_BLACK, "Coins _1_$" + player.coins);
    drawColoredText(x + 5, y + 15, COLOR_MID_GRAY, COLOR_BLACK, calendarString());

    # messages
    y := message_y;
    drawRect(x, y, x + (320 - x - 5), y + ((5 + TILE_H * MAP_VIEW_H) - y), color); 
    drawGameMessages(x, message_y + 90);

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
}

def showGameHelp() {
    clearGameMessages();
    longMessage := true;
    gameMessage("_1_Arrows: movement/attack", COLOR_MID_GRAY);
    gameMessage("_1_H: help", COLOR_MID_GRAY);
    gameMessage("_1_C: character sheet", COLOR_MID_GRAY);
    gameMessage("_1_A: awards and skills", COLOR_MID_GRAY);
    gameMessage("_1_E: change equipment", COLOR_MID_GRAY);
    gameMessage("_1_I: party inventory", COLOR_MID_GRAY);
    gameMessage("_1_T: talk", COLOR_MID_GRAY);
    gameMessage("_1_R: ranged attack in combat", COLOR_MID_GRAY);
    gameMessage("_1_Space: search/use door", COLOR_MID_GRAY);
    gameMessage("_1_Enter: use stairs/gate", COLOR_MID_GRAY);
    gameMessage("_1_Numbers: switch pc / option in conversation or trade", COLOR_MID_GRAY);
    longMessage := false;
}
