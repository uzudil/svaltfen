def newChar(name, imgName) {
    eq := {};
    array_foreach(SLOTS, (s, slot) => {
        eq[slot] := null;
    });
    pc := {
        "name": name,
        "pos": [0, 0],
        "hp": 10,
        "startHp": 10,
        "image": img[imgName],
        "hunger": 0,
        "thirst": 0,
        "exp": 0,
        "level": 1,
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
    pc.hp := min(pc.hp + amount, pc.startHp * pc.level);
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

def calculateArmor(pc) {
    armorBonus := max(0, pc.dex - 15) + max(0, pc.speed - 18);
    invArmor := array_map(array_filter(SLOTS, slot => {
        if(pc.equipment[slot] != null) {
            return ITEMS_BY_NAME[pc.equipment[slot].name]["ac"] != null;
        }
        return false;
    }), slot => pc.equipment[slot]);
    pc.armor := array_reduce(invArmor, armorBonus, (value, invItem) => {
        return value + ITEMS_BY_NAME[invItem.name].ac;
    });

    attackBonus := int(pc.level / 3) + max(0, pc.str - 18) + max(0, pc.dex - 18);
    weaponSlots := getWeaponSlots(pc);
    pc.attack := array_map(weaponSlots, slot => {
        invItem := pc.equipment[slot];
        dam := ITEMS_BY_NAME[invItem.name].dam;
        return {
            "dam": [dam[0] + attackBonus, dam[1] + attackBonus],
            "weapon": invItem.name,
            "slot": slot,
        };
    });
    if(len(weaponSlots) = 0) {
        pc.attack := [ {
            "dam": [attackBonus, attackBonus + 2],
            "weapon": "Bare hands",
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
        return true;
    }
    if(invItem.life < 4) {
        gameMessage(invItem.name + " cracks!", COLOR_RED);
    }
    return false;
}
