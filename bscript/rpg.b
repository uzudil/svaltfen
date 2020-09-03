def newChar(name, imgName, level) {
    eq := {};
    array_foreach(SLOTS, (s, slot) => {
        eq[slot] := null;
    });
    exp := 0;
    if(level > 1) {
        exp := 700 * pow(2, level - 1);
    }
    pc := {
        "name": name,
        "pos": [0, 0],
        "hp": 10 * level,
        "startHp": 10,
        "image": img[imgName],
        "hunger": 0,
        "thirst": 0,
        "exp": exp,
        "level": level,
        "attack": [],
        "armor": 0,
        "str": roll(15, 20),
        "dex": roll(15, 20),
        "speed": roll(15, 20),
        "int": roll(15, 20),
        "wis": roll(15, 20),
        "cha": roll(15, 20),
        "luck": roll(15, 20),
        "equipment": eq,        
    };
    calculateArmor(pc);
    return pc;
}

def getNextLevelExp(pc) {
    return 700 * pow(2, pc.level - 1);
}

def gainExp(pc, amount) {
    pc.exp := pc.exp + amount;    
    while(pc.exp >= getNextLevelExp(pc)) {
        pc.level := pc.level + 1;
        pc.hp := pc.startHp * pc.level;
        gameMessage(pc.name + " is now level " + pc.level + "!", COLOR_GREEN);
    }
}

def gainHp(pc, amount) {
    old := pc.hp;
    # dead characters can't heal
    if(pc.hp > 0) {    
        pc.hp := min(pc.hp + amount, pc.startHp * pc.level);
    }
    if(pc.hp > old) {
        gameMessage(pc.name + " gains " + (pc.hp - old) + " health points.", COLOR_GREEN);
    } else {
        gameMessage("Nothing happens.", COLOR_MID_GRAY);
    }
}

def eat(pc, amount) {
    pc.hunger := max(0, pc.hunger - amount);    
}

def describeHunger(pc) {
    if(pc.hunger < 5) {
        return "Not hungry";
    }
    if(pc.hunger < 10) {
        return "Hungry";
    }
    if(pc.hunger < 15) {
        return "Ravenous";
    }
    return "Starving";
}

def describeThirst(pc) {
    if(pc.hunger < 5) {
        return "Not thirsty";
    }
    if(pc.hunger < 10) {
        return "Thirsty";
    }
    if(pc.hunger < 15) {
        return "Parched";
    }
    return "Dehydrated";
}

def drink(pc, amount) {
    pc.thirst := max(0, pc.thirst - amount);    
}

def calculateTorchLight() {
    player.light := 1;
    i := 0;
    while(i < len(player.party)) {
        pc := player.party[i];
        array_foreach(SLOTS, (t, slot) => {
            eq := pc.equipment[slot];
            if(eq != null) {
                item := ITEMS_BY_NAME[eq.name];
                if(item["light"] != null) {
                    if(item.light > player.light) {
                        player.light := item.light;
                    }
                }
            }
        });
        i := i + 1;
    }
}

def calculateArmor(pc) {
    armorBonus := max(0, pc.dex - 15) + max(0, pc.speed - 18);
    invArmor := array_map(array_filter(SLOTS, slot => {
        if(pc.equipment[slot] != null) {
            return ITEMS_BY_NAME[pc.equipment[slot].name]["ac"] != null;
        }
        return false;
    }), slot => pc.equipment[slot]);
    pc.armor := array_reduce(invArmor, armorBonus, (value, invItem) => {
        invItem := ITEMS_BY_NAME[invItem.name];
        return value + invItem.ac + invItem.bonus;
    });

    attackBonus := int(pc.level / 3) + max(0, pc.str - 18) + max(0, pc.dex - 18);
    weaponSlots := getWeaponSlots(pc);
    pc.attack := array_map(weaponSlots, slot => {
        invItem := pc.equipment[slot];
        realItem := ITEMS_BY_NAME[invItem.name];
        dam := realItem.dam;
        return {
            "dam": [dam[0] + attackBonus, dam[1] + attackBonus],
            "weapon": invItem.name,
            "bonus": realItem.bonus,
            "slot": slot,
        };
    });
    if(len(weaponSlots) = 0) {
        pc.attack := [ {
            "dam": [attackBonus, attackBonus + 2],
            "weapon": "Bare hands",
            "bonus": 0,
            "slot": null,
        } ];
    }
}

def getWeaponSlots(pc) {
    return array_filter(SLOTS, slot => {
        if(pc.equipment[slot] != null) {
            return ITEMS_BY_NAME[pc.equipment[slot].name]["dam"] != null;
        }
        return false;
    });
}

def getToHitBonus(pc) {
    tohit := int(pc.level / 3) + max(0, pc.dex - 18) + max(0, pc.speed - 18);
    if(getGameState("mark_of_fregnar") != null) {
        tohit := tohit + 2;
    }
    return tohit;
}

def decItemLife(pc, slot) {
    invItem := pc.equipment[slot];
    invItem.life := invItem.life - 1;
    if(invItem.life <= 0) {
        gameMessage(invItem.name + " breaks!", COLOR_RED);
        pc.equipment[slot] := null;
        calculateTorchLight();
        return true;
    }
    if(invItem.life < 4) {
        gameMessage(invItem.name + " cracks!", COLOR_RED);
    }
    return false;
}

def joinParty(npc, level) {
    gameMessage(npc.name + " joins you as a companion!", COLOR_YELLOW);
    ch := newChar(npc.name, blocks[npc.block].img, 3);
    # todo: add some equipment/spells/etc
    ch["index"] := len(player.party);
    player.party[len(player.party)] := ch;
    removeNpc(npc.name);
    endConvo();
    saveGame();
}
