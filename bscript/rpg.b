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
        "state": array_map(STATES, state => state.default),
        "save": array_map(STATES, state => 0),
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
        levelUpSound();
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
        gameMessage("Nothing happens for " + pc.name + ".", COLOR_MID_GRAY);
    }
}

def takeDamage(pc, dam) {
    if(pc.hp > 0) {
        gameMessage(pc.name + " takes " + dam + " damage!", COLOR_RED);
        pc.hp := max(pc.hp - dam, 0);
        if(pc.hp = 0) {
            gameMessage(pc.name + " dies!", COLOR_RED);
            # return dead pc-s equipment to pool so someone else can use it
            array_foreach(SLOTS, (i, slot) => {
                if(pc.equipment[slot] != null) {
                    player.inventory[len(player.inventory)] := pc.equipment[slot];
                    pc.equipment[slot] := null;
                }
            });
            calculateArmor(pc);
            calculateTorchLight();
        }
    }
}

def eat(pc, amount) {
    index := STATE_NAME_INDEX[STATE_HUNGER];
    pc.state[index] := min(max(0, pc.state[index] + amount * 10), 100);    
    a := describeHunger(pc);
    gameMessage(pc.name + " is " + a[0], a[1]);
    trace("state=" + pc.state);
}

def drink(pc, amount) {
    index := STATE_NAME_INDEX[STATE_THIRST];
    pc.state[index] := min(max(0, pc.state[index] + amount * 10), 100);
    a := describeThirst(pc);
    gameMessage(pc.name + " is " + a[0], a[1]);
    trace("state=" + pc.state);
}

def resurrect(pc) {
    gameMessage(pc.name + " returns to life!", COLOR_GREEN);
    pc.hp := 1; 
    gainHp(pc, pc.level * pc.startHp); 
    resetStats(pc);
}

def cureAilments(pc) {
    if(setState(pc, STATE_POISON, 0) = false && setState(pc, STATE_PARALYZE, 0) = false && 
        setState(pc, STATE_CURSE, 0) = false && setState(pc, STATE_SCARED, 0) = false) {
        gameMessage("Nothing happens for " + pc.name + ".", COLOR_MID_GRAY);
    } else {
        gameMessage(pc.name + " suddenly feels better!", COLOR_GREEN);
    }
}

def setState(pc, state, value) {
    index := STATE_NAME_INDEX[state];
    oldValue := pc.state[index];
    newValue := max(0, min(pc.state[index] + value, value));
    if(newValue <= oldValue || random() * 20 >= pc.save[index]) {
        pc.state[index] := newValue;
        calculateArmor(pc);
    }
    if(oldValue = 0 && pc.state[index] > 0) {
        gameMessage(pc.name + " is now " + state + "!", STATES[index].color);
        return true;
    }
    if(oldValue > 0 && pc.state[index] = 0) {
        gameMessage(pc.name + " is no longer " + state + "!", COLOR_GREEN);
        return true;
    }
    return false;
}

def resetStats(pc) {
    pc.state := [];
    array_foreach(STATES, (t, state) => {
        pc.state[t] := state.default;
        pc.save[t] := 0;
    });
}

def describeHunger(pc) {
    value := pc.state[STATE_NAME_INDEX[STATE_HUNGER]];
    msg := "";
    color := COLOR_MID_GRAY;
    if(value = 0) {
        msg := "starving!";
        color := COLOR_YELLOW;
    } else {
        if(value < 5) {
            msg := "famished!";
            color := COLOR_YELLOW;
        } else {
            if(value < 25) {
                msg := "hungry!";
                color := COLOR_YELLOW;
            } else {
                if(value > 80) {
                    msg := "pleasently full";
                    color := COLOR_GREEN;
                } else {
                    msg := "not hungry";
                }
            }
        }
    }
    return [ msg, color ];    
}

def describeThirst(pc) {
    value := pc.state[STATE_NAME_INDEX[STATE_THIRST]];
    msg := "";
    color := COLOR_MID_GRAY;
    if(value = 0) {
        msg := "dying of thirst!";
        color := COLOR_YELLOW;
    } else {
        if(value < 5) {
            msg := "parched!";
            color := COLOR_YELLOW;
        } else {
            if(value < 25) {
                msg := "thirsty!";
                color := COLOR_YELLOW;
            } else {
                if(value > 80) {
                    msg := "well hydrated";
                    color := COLOR_GREEN;
                } else {
                    msg := "not thirsty";
                }
            }
        }
    }
    return [ msg, color ];    
}

def getStateEffect(pc, effectFx) {
    return array_reduce(STATES, 0, (value, st) => {
        index := STATE_NAME_INDEX[st.name];
        if(pc.state[index] > 0 && st[effectFx] != null) {
            value := value + st[effectFx](pc);
        }
        return value;
    });
}

def anyPcInState(state) {
    return array_find(player.party, pc => isPcInState(pc, state)) != null;
}

def isPcInState(pc, state) {
    return pc.state[STATE_NAME_INDEX[state]] > 0;
}

def isPcIncapacitated(pc) {
    return isPcInState(pc, STATE_PARALYZE) || pc.hp <= 0;
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
    pc["save"] := array_map(STATES, state => 0);
    array_foreach(SLOTS, (i, slot) => {
        if(pc.equipment[slot] != null) {
            item := ITEMS_BY_NAME[pc.equipment[slot].name];
            array_foreach(STATES, (stateIndex, state) => {
                if(item.save[state.name] != null) {
                    pc.save[stateIndex] := pc.save[stateIndex] + item.save[state.name];
                }
            });
        }
    });

    armorBonus := max(0, pc.dex - 15) + max(0, pc.speed - 18) + getStateEffect(pc, "getArmorMod");
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

    attackBonus := int(pc.level / 3) + max(0, pc.str - 18) + max(0, pc.dex - 18) + getStateEffect(pc, "getAttackMod");
    weaponSlots := getWeaponSlots(pc);
    pc.attack := array_map(weaponSlots, slot => {
        invItem := pc.equipment[slot];
        realItem := ITEMS_BY_NAME[invItem.name];
        dam := realItem.dam;
        return {
            "dam": [dam[0] + attackBonus, dam[1] + attackBonus],
            "weapon": invItem.name,
            "bonus": realItem.bonus,
            "bonusVs": realItem.bonusVs,
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

    if(pc.equipment[SLOT_RANGED] != null) {
        item := ITEMS_BY_NAME[pc.equipment[SLOT_RANGED].name];
        pc["ranged"] := {
            "dam": [ item.dam[0] + attackBonus, item.dam[1] + attackBonus ],
            "weapon": item.name,
            "bonus": item.bonus,
            "slot": SLOT_RANGED,
        };
    } else {
        pc["ranged"] := null;
    }
}

def getWeaponSlots(pc) {
    return array_filter(SLOTS, slot => {
        if(pc.equipment[slot] != null) {
            return slot != SLOT_RANGED && ITEMS_BY_NAME[pc.equipment[slot].name]["dam"] != null;
        }
        return false;
    });
}

def getToHitBonus(pc) {
    tohit := int(pc.level / 3) + max(0, pc.dex - 18) + max(0, pc.speed - 18) + getStateEffect(pc, "getToHitMod");
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
        equipmentFailSound(3);
        return true;
    }
    if(invItem.life < 4) {
        gameMessage(invItem.name + " cracks!", COLOR_RED);
        equipmentFailSound(2);
    }
    return false;
}

def joinParty(npc, level) {
    gameMessage(npc.name + " joins you as a companion!", COLOR_YELLOW);
    ch := newChar(npc.name, blocks[npc.block].img, level);
    # todo: add some equipment/spells/etc
    ch["index"] := len(player.party);
    player.party[len(player.party)] := ch;
    removeNpc(npc.name);
    endConvo();
    saveGame();
}

def gainSpells() {
    maxLevel := array_reduce(player.party, 0, (level, pc) => max(level, pc.level));
    level := 0;
    newSpells := [];
    while(level < maxLevel && level < len(SPELLS)) {
        spells := array_filter(SPELLS[level], spell => array_find_index(player.magic, spellName => spellName = spell.name) = -1);
        array_foreach(spells, (i, sp) => {
            player.magic[len(player.magic)] := sp.name; 
            newSpells[len(newSpells)] := sp.name;
        });
        level := level + 1;
    }
    if(len(newSpells) > 0) {
        player.spellCount := 0;
        gameMessage("You learn new magic spells!", COLOR_GREEN);
    }
    return newSpells;
}

def incSpellCount(level) {
    if(player["spellCount"] = null) {
        player["spellCount"] := level;
    } else {
        player.spellCount := player.spellCount + level;
    }
    saveGame();
}

def resetSpellCount() {
    player["spellCount"] := 0;
    saveGame();
}

def canCastSpell() {
    if(player["spellCount"] = null) {
        return true;
    } else {
        return player.spellCount <= getSpellPoints();
    }
}

def getSpellPoints() {
    maxLevel := array_reduce(player.party, 0, (level, pc) => max(level, pc.level));
    return maxLevel * 3;
}
