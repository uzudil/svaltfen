const SAVE_ACID = "acid";
const SAVE_FIRE = "fire";
const SAVE_ELECTRICITY = "electricity";
const SAVE_MIND = "mind";

SPELLS := [];
SPELLS_BY_NAME := {};

def initMagic() {
    SPELLS := [
        [
            { "name": "Party rations", "onParty": self => createFood(5), },
            { "name": "Minor Healing", "onPc": (self, pc) => gainHp(pc, 10), },
            { "name": "Protect Ally", "onPc": (self, pc) => setState(pc, STATE_SHIELD, 150), },
        ],
        [
            { 
                "name": "Magic Arrow", 
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(3, int(pc.level / 2));
                    return playerSpellAttack([ level + "arrow", level + "arrow2" ], [2 + level, 6 + level], pc.level, SAVE_MIND);
                },
                "isCombat": true, 
            },
            { "name": "Cure Poison", "onPc": (self, pc) => setState(pc, STATE_POISON, 0) },
            { 
                "name": "Cast Light",  
                "onParty": self => {
                    if(player.light = 1) {
                        player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Torch"]);
                        pc := player.party[0];
                        pcDonItem(pc, len(player.inventory) - 1, getFreeHandSlot(pc));
                        gameMessage("A burning torch appears in your hand!", COLOR_GREEN);
                    } else {
                        gameMessage("Your magic fizzles and nothing happens.", COLOR_MID_GRAY);
                    }
                },
            },
            { 
                "name": "Wall of Force",
                "onLocation" : (self, x, y) => { 
                    addBarrier(x, y);
                    return 3;
                },
            },
            { 
                "name": "Destroy Barrier",
                "onLocation" : (self, x, y) => { 
                    delBarrier(x, y);
                    return 3;
                },
            },
        ],
        [
            { "name": "Party feast", "onParty": self => createFood(10), },        
            { "name": "Full Healing", "onPc": (self, pc) => gainHp(pc, pc.level * pc.startHp), },
            { 
                "name": "Remember Location", 
                "onParty": self => {
                    storeLocation();
                } 
            },
            { 
                "name": "Return to Location",
                "onParty": self => {
                    recallLocation();
                }  
            },
            { 
                "name": "Reveal Secrets",
                "onLocation": (self, x, y) => {
                    if(gameSearchQuiet(x, y)) {
                        actionSound();
                    }
                    return 3;
                }
            },
            { 
                "name": "Venom Ray", 
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(4, int(pc.level / 2));
                    return playerSpellAttack([ "acid", "acid" ], [6 + level, 10 + level], pc.level, SAVE_ACID);
                },
                "isCombat": true, 
            },
        ],
        [
            { "name": "Remove Curse", "onPc": (self, pc) => setState(pc, STATE_CURSE, 0) },
            { "name": "Heal All", "onParty": self => array_foreach(player.party, (i, pc) => gainHp(pc, pc.level * pc.startHp)), },
            { "name": "Protect All", "onParty": self => array_foreach(player.party, (i, pc) => setState(pc, STATE_SHIELD, 150)), },
            { 
                "name": "Summon Monster",
                "onLocation" : (self, x, y) => { 
                    trace("casting at: " + x + "," + y);
                    # todo
                },
                "isCombat": true, 
            },
            { 
                "name": "Telekinesis",  
                "onLocation": (self, x, y) => {
                    if(gameUseDoor(x, y)) {
                        actionSound();
                    }
                    return 3;
                }
            },
            { 
                "name": "View Map",
                "onParty": self => {
                    gameShowMap();
                } 
            },
            { 
                "name": "Acid Cloud",
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(4, int(pc.level / 2));
                    return playerAreaSpellAttack([ "acid", "acid" ], [6 + level, 10 + level], pc.level, 2 + pc.level / 2, SAVE_ACID);
                },
                "isCombat": true,
            },
            { 
                "name": "Flame Arrow", 
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(4, int(pc.level / 2));
                    return playerSpellAttack([ "fireball", "fireball" ], [8 + level, 15 + level], pc.level, SAVE_FIRE);
                },
                "isCombat": true, 
            },
        ],
        [
            { 
                "name": "Fireball",
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(3, int(pc.level / 2));
                    return playerAreaSpellAttack([ "fireball", "fireball" ], [10 + level, 16 + level], pc.level, 2 + pc.level / 2, SAVE_FIRE);
                },
                "isCombat": true,
            },
            { 
                "name": "Command Monster",
                "onLocation" : (self, x, y) => { 
                    trace("casting at: " + x + "," + y);
                    # todo
                },
                "isCombat": true,
                "save": SAVE_MIND,  
            },
            { "name": "Free from Charm", "onPc": (self, pc) => setState(pc, STATE_CHARM, 0) },
            { "name": "Bless Party", "onParty": self => array_foreach(player.party, (i, pc) => setState(pc, STATE_BLESS, 150)), },
        ],
        [
            { 
                "name": "Petrification",
                "onLocation" : (self, x, y) => { 
                    trace("casting at: " + x + "," + y);
                    # todo
                },
                "isCombat": true,
                "save": SAVE_MIND, 
            },
            { "name": "Cure Paralysis", "onPc": (self, pc) => setState(pc, STATE_PARALYZE, 0), },
            { 
                "name": "Summon Demon",
                "onLocation" : (self, x, y) => { 
                    trace("casting at: " + x + "," + y);
                },
                "isCombat": true, 
            },
            { 
                "name": "Lightning Strike",
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(4, int(pc.level / 2));
                    return playerSpellAttack([ "zap2", "zap" ], [15 + level, 25 + level], pc.level, SAVE_ELECTRICITY);
                },
                "isCombat": true, 
            },
            { "name": "Invisibility", "onPc": (self, pc) => setState(pc, STATE_INVISIBLE, 150), },
        ],
        [
            { "name": "Resurrection", "onPc": (self, pc) => resurrect(pc), },
            { 
                "name": "Earthquake", 
                "isCombat": true, 
                "save": SAVE_MIND, 
                "onLocation": (self, x, y) => {
                    pc := player.party[0];
                    level := min(3, int(pc.level / 2));
                    return playerQuakeSpellAttack([ "zap2", "zap" ], [8 + level, 12 + level], pc.level);
                } 
            },
            { "name": "Cure All Ailments", "onParty": self => array_foreach(player.party, (i, pc) => cureAilments(pc)), },
        ],
    ];

    SPELLS_BY_NAME := array_reduce(SPELLS, {}, (d, level) => { array_foreach(level, (i, s) => { d[s.name] := s; }); return d; });
}

def createFood(n) {
    range(0, n, 1, i => {
        player.inventory[len(player.inventory)] := itemInstance(getRandomItem([OBJECT_FOOD,OBJECT_DRINK], 10));
    });
    gameMessage("Your magic has created food and drink!", COLOR_GREEN);
}

def getFreeHandSlot(pc) {
    slot := SLOT_LEFT_HAND;
    if(pc.equipment[slot] != null) {
        slot := SLOT_RIGHT_HAND;
    }
    return slot;
}
