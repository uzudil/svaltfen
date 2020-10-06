const SAVE_ACID = "acid";
const SAVE_FIRE = "fire";
const SAVE_ELECTRICITY = "electricity";
const SAVE_MIND = "mind";

const SPELL_TYPE_AID = "aid";
const SPELL_TYPE_ATTACK = "attack";
const SPELL_TYPE_EXPLORE = "explore";
const SPELL_TYPE_OTHER = "other";
const SPELL_TYPES = [ SPELL_TYPE_AID, SPELL_TYPE_ATTACK, SPELL_TYPE_EXPLORE, SPELL_TYPE_OTHER ];

SPELLS := [];
SPELLS_BY_NAME := {};

def initMagic() {
    SPELLS := [
        [
            { "name": "Party rations", "onParty": self => createFood(5), "type": SPELL_TYPE_AID },
            { "name": "Minor Healing", "onPc": (self, pc) => gainHp(pc, 10), "type": SPELL_TYPE_AID },
            { "name": "Protect Ally", "onPc": (self, pc) => setState(pc, STATE_SHIELD, 150), "type": SPELL_TYPE_AID },
        ],
        [
            { 
                "name": "Magic Arrow", 
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(3, int(pc.level / 2));
                    playerSpellAttack([ level + "arrow", level + "arrow2" ], [2 + level, 6 + level], pc.level, SAVE_MIND);
                },
                "isCombat": true, 
                "type": SPELL_TYPE_ATTACK
            },
            { "name": "Cure Poison", "onPc": (self, pc) => setState(pc, STATE_POISON, 0), "type": SPELL_TYPE_AID },
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
                "type": SPELL_TYPE_EXPLORE
            },
            { 
                "name": "Wall of Force",
                "onLocation" : (self, x, y) => addBarrier(x, y),
                "type": SPELL_TYPE_OTHER
            },
            { 
                "name": "Destroy Barrier",
                "onLocation" : (self, x, y) => delBarrier(x, y),
                "type": SPELL_TYPE_OTHER
            },
        ],
        [
            { "name": "Party feast", "onParty": self => createFood(10), "type": SPELL_TYPE_AID },
            { "name": "Full Healing", "onPc": (self, pc) => gainHp(pc, pc.level * pc.startHp), "type": SPELL_TYPE_AID },
            { 
                "name": "Remember Location", 
                "onParty": self => storeLocation(),
                "type": SPELL_TYPE_OTHER
            },
            { 
                "name": "Return to Location",
                "onParty": self => recallLocation(),
                "type": SPELL_TYPE_OTHER  
            },
            { 
                "name": "Reveal Secrets",
                "onLocation": (self, x, y) => {
                    if(gameSearchQuiet(x, y)) {
                        actionSound();
                    }
                },
                "type": SPELL_TYPE_EXPLORE
            },
            { 
                "name": "Venom Ray", 
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(4, int(pc.level / 2));
                    playerSpellAttack([ "acid", "acid" ], [6 + level, 10 + level], pc.level, SAVE_ACID);
                },
                "isCombat": true, 
                "type": SPELL_TYPE_ATTACK
            },
            {
                "name": "Enchant weapons",
                "type": SPELL_TYPE_OTHER,
                "onParty": self => {
                    changed := [ false ];
                    array_foreach([ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], (i, slot) => {   
                        if(player.party[0].equipment[slot] != null) {
                            item := player.party[0].equipment[slot];
                            itemTmpl := ITEMS_BY_NAME[item.name];
                            if(itemTmpl.type = OBJECT_WEAPON && itemTmpl.bonus = 0) {
                                if(player.party[0].level < 5) {
                                    name := "+1 " + item.name;
                                } else {
                                    name := "+2 " + item.name;
                                }
                                player.party[0].equipment[slot] := itemInstance(ITEMS_BY_NAME[name]);
                                changed[0] := true;
                            }
                        }
                    });
                    if(changed[0]) {
                        calculateArmor(player.party[0]);
                        gameMessage("You successfully enchanted some weapons!", COLOR_GREEN);
                    } else {
                        gameMessage("Nothing happens.", COLOR_MID_GRAY);
                    }
                },
            }
        ],
        [
            { "name": "Remove Curse", "onPc": (self, pc) => setState(pc, STATE_CURSE, 0), "type": SPELL_TYPE_AID },
            { "name": "Heal All", "onParty": self => array_foreach(player.party, (i, pc) => gainHp(pc, pc.level * pc.startHp)), "type": SPELL_TYPE_AID },
            { "name": "Protect All", "onParty": self => array_foreach(player.party, (i, pc) => setState(pc, STATE_SHIELD, 150)), "type": SPELL_TYPE_AID },
            { 
                "name": "Summon Monster",
                "onLocation" : (self, x, y) => summonMonster(x, y),
                "isCombat": true, 
                "type": SPELL_TYPE_ATTACK
            },
            { 
                "name": "Telekinesis",  
                "onLocation": (self, x, y) => {
                    if(gameUseDoor(x, y)) {
                        actionSound();
                    }
                },
                "type": SPELL_TYPE_EXPLORE
            },
            { 
                "name": "View Map",
                "onParty": self => {
                    gameShowMap();
                },
                "type": SPELL_TYPE_EXPLORE
            },
            { 
                "name": "Acid Cloud",
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(4, int(pc.level / 2));
                    playerAreaSpellAttack([ "acid", "acid" ], [6 + level, 10 + level], pc.level, 2 + pc.level / 2, SAVE_ACID);
                },
                "isCombat": true,
                "type": SPELL_TYPE_ATTACK
            },
            { 
                "name": "Flame Arrow", 
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(4, int(pc.level / 2));
                    playerSpellAttack([ "fireball", "fireball" ], [8 + level, 15 + level], pc.level, SAVE_FIRE);
                },
                "isCombat": true, 
                "type": SPELL_TYPE_ATTACK
            },
        ],
        [
            { 
                "name": "Fireball",
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(3, int(pc.level / 2));
                    playerAreaSpellAttack([ "fireball", "fireball" ], [10 + level, 16 + level], pc.level, 2 + pc.level / 2, SAVE_FIRE);
                },
                "isCombat": true,
                "type": SPELL_TYPE_ATTACK
            },
            { 
                "name": "Frightening Visions",
                "onLocation" : (self, x, y) => setMonsterStateAt(self, x, y, STATE_SCARED),
                "isCombat": true,
                "save": SAVE_MIND,
                "type": SPELL_TYPE_ATTACK
            },
            { "name": "Disspell Fear", "onPc": (self, pc) => setState(pc, STATE_SCARED, 0), "type": SPELL_TYPE_AID },
            { "name": "Bless Party", "onParty": self => array_foreach(player.party, (i, pc) => setState(pc, STATE_BLESS, 150)), "type": SPELL_TYPE_AID },
        ],
        [
            { 
                "name": "Petrification",
                "onLocation" : (self, x, y) => setMonsterStateAt(self, x, y, STATE_PARALYZE),
                "isCombat": true,
                "save": SAVE_MIND, 
                "type": SPELL_TYPE_ATTACK
            },
            { "name": "Cure Paralysis", "onPc": (self, pc) => setState(pc, STATE_PARALYZE, 0), "type": SPELL_TYPE_AID },
            { 
                "name": "Summon Demon",
                "onLocation" : (self, x, y) => summonDemon(x, y),
                "isCombat": true, 
                "type": SPELL_TYPE_ATTACK
            },
            { 
                "name": "Lightning Strike",
                "onLocation" : (self, x, y) => { 
                    pc := player.party[0];
                    level := min(4, int(pc.level / 2));
                    playerSpellAttack([ "zap2", "zap" ], [15 + level, 25 + level], pc.level, SAVE_ELECTRICITY);
                },
                "isCombat": true, 
                "type": SPELL_TYPE_ATTACK
            },
            { "name": "Invisibility", "onPc": (self, pc) => setState(pc, STATE_INVISIBLE, 150), "type": SPELL_TYPE_AID },
        ],
        [
            { "name": "Resurrection", "onPc": (self, pc) => resurrect(pc), "type": SPELL_TYPE_AID },
            { 
                "name": "Earthquake", 
                "isCombat": true, 
                "save": SAVE_MIND, 
                "onLocation": (self, x, y) => {
                    pc := player.party[0];
                    level := min(3, int(pc.level / 2));
                    playerQuakeSpellAttack([ "zap2", "zap" ], [8 + level, 12 + level], pc.level);
                },
                "type": SPELL_TYPE_ATTACK
            },
            { "name": "Cure All Ailments", "onParty": self => array_foreach(player.party, (i, pc) => cureAilments(pc)), "type": SPELL_TYPE_AID },
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

def setMonsterStateAt(spell, x, y, state) {
    monster := getMonsterAt(x, y);
    if(monster = null) {
        gameMessage("Nothing happens.", COLOR_MID_GRAY);
    } else {
        savemod := getHitMod(monster, spell.save);
        if(roll(0, 10) > savemod) {
            monster.state[state] := 10;
            gameMessage("The creature is now " + state + "!", COLOR_GREEN);
        } else {
            gameMessage("The magic is ineffective!", COLOR_MID_GRAY);
        }
    }
}
