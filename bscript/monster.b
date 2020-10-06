# monster combat:
# armor is used for defense and as toHitBonus
# attack is rolled as [min, max]
# level determines exp gains and coins (if in "drops" array)
MONSTERS := [
    { "name": "Giant Rat", "block": "rat", 
        "attack": [0,3], "range": 1, "attackAp": 3, "armor": 0, "startHp": 11, "level": 1, "speed": 15 
    },
    { "name": "Large Bat", "block": "bat", 
        "attack": [0,3], "range": 1, "attackAp": 2, "armor": 0, "startHp": 8, "level": 1, "speed": 14 
    },
    { "name": "Animated Skeleton", "block": "skeleton", 
        "attack": [2,4], "range": 1, "attackAp": 3, "armor": 4, "startHp": 16, "level": 2, "speed": 8, "hit_mods": { "fire": 5 }, 
    },
    { "name": "Skeleton Archer", "block": "skeletona", 
        "drops": [ "coins", "Composite Bow" ],    
        "attack": [1,3], "range": 6, "attackAp": 3, "armor": 4, "startHp": 16, "level": 2, "speed": 8, "hit_mods": { "fire": 5, "mind": -2 }, 
    },
    { "name": "Nixbeetle", "block": "beetle", 
        "onDeath": self => {
            if(getGameState("nixbeetle_quest") != null && getGameState("nixbeetle_trophy") = null) {
                setGameState("nixbeetle_trophy", true);
                saveGame();
                gameMessage("You take a bloody piece of the dead beetle's carapce with you.", COLOR_GREEN);
            }
        },
        "attack": [2,5], 
        "onHit": (self, pc) => {
            # there is a chance the character becomes poisoned
            if(random() >= 0.75) {
                setState(pc, STATE_POISON, 10);
            }
        }, 
        "range": 5, "rangeBlocks": [ "acid", "acid" ], "attackAp": 4, "armor": 5, "startHp": 24, "level": 3, "speed": 15, "hit_mods": { "acid": -5 },  
    },
    { "name": "Skeleton Warrior", "block": "skeleton2", 
        "drops": [ "Soldier's sword", "Small shield", "coins" ],
        "attack": [6,10], "range": 1, "attackAp": 3, "armor": 7, "startHp": 32, "level": 4, "speed": 8, "hit_mods": { "fire": 5 },   
    },
    { "name": "Specter", "block": "ghost", 
        "onHit": (self, pc) => {
            # there is a chance the character becomes poisoned
            if(random() >= 0.75) {
                setState(pc, STATE_CURSE, 10);
            }
            if(random() >= 0.75) {
                setState(pc, STATE_SCARED, 10);
            }
        }, 
        "drops": [ "coins" ],
        "attack": [1,2], "range": 1, "attackAp": 2, "armor": 16, "startHp": 15, "level": 5, "speed": 16, "hit_mods": { "mind": -5, "electricity": -5 },   
    },
    { "name": "Vegetal Warrior", "block": "vegwar", 
        "onHit": (self, pc) => {
            # there is a chance the character becomes poisoned
            if(random() >= 0.75) {
                setState(pc, STATE_POISON, 10);
            }
        }, 
        "drops": [ "coins", "Lance", "Round potion" ],
        "attack": [5,9], "range": 1, "attackAp": 4, "armor": 12, "startHp": 42, "level": 6, "speed": 4, 
        "hit_mods": { "fire": 5, "acid": 5, "electricity": -5, },   
    },
    { "name": "Gnork", "block": "gnork", 
        "drops": [ "coins", "Warhammer", "Kite shield", "Oval potion" ],
        "attack": [6,8], "range": 1, "attackAp": 3, "armor": 10, "startHp": 48, "level": 6, "speed": 4, "hit_mods": { "acid": -5 },   
    },
    { "name": "Gnork Archer", "block": "gnorka", 
        "drops": [ "coins", "Longbow", "Round potion" ],
        "attack": [2,5], "range": 6, "attackAp": 3, "armor": 10, "startHp": 48, "level": 6, "speed": 4, "hit_mods": { "acid": -5 },   
    },    
    { "name": "Vampire Bat", "block": "vbat", 
        "attack": [5,10], "range": 1, "attackAp": 2, "armor": 0, "startHp": 60, "level": 6, "speed": 14,
        "drops": [ "coins" ],
        "onHit": (self, pc) => {
            if(random() >= 0.75) {
                setState(pc, STATE_CURSE, 10);
            }
        }, 
        "hit_mods": { "acid": 5, "electricity": 2 },  
    },
    { "name": "Green Mold", "block": "slime1", 
        "drops": [ "coins" ],
        "onHit": (self, pc) => {
            if(random() >= 0.75) {
                setState(pc, STATE_POISON, 10);
            }
        }, 
        "attack": [4,5], "range": 1, "attackAp": 4, "armor": 18, "startHp": 20, "level": 6, "speed": 3, 
        "hit_mods": { "acid": -5, "fire": 5, "electricity": -3 },   
    },
    { "name": "Draconian", "block": "draconian", 
        "drops": [ "coins", "Greatsword", "Oval potion" ],
        "attack": [6,8], "range": 1, "attackAp": 4, "armor": 14, "startHp": 50, "level": 6, "speed": 3, 
        "hit_mods": { "fire": -5, "electricity": -5, "acid": 5, "mind": 3 },   
        "onHit": (self, pc) => {
            # there is a chance the character becomes poisoned
            if(random() >= 0.75) {
                setState(pc, STATE_SCARED, 10);
            }
        }, 
    },
    { "name": "Demon Grunt", "block": "demon", 
        "drops": [ "coins", "Lance", "Oval potion" ],
        "attack": [6,9], "range": 1, "attackAp": 3, "armor": 11, "startHp": 52, "level": 7, "speed": 8,
        "hit_mods": { "fire": -5 },    
        "onHit": (self, pc) => {
            # there is a chance the character becomes poisoned
            if(random() >= 0.75) {
                setState(pc, STATE_SCARED, 10);
            }
        }, 
    },
    { "name": "Demon Archer", "block": "demona", 
        "drops": [ "coins", "Longbow", "Oval potion" ],
        "attack": [2,5], "range": 6, "attackAp": 3, "armor": 11, "startHp": 52, "level": 7, "speed": 8,
        "hit_mods": { "fire": -5, "mind": -5 },     
    },
    { "name": "Cult Fanatic", "block": "cultist", 
        "drops": [ "coins", "Lance", "Oval potion" ],
        "onHit": (self, pc) => {
            if(random() >= 0.75) {
                setState(pc, STATE_CURSE, 10);
            }
        }, 
        "attack": [5,8], "range": 1, "attackAp": 3, "armor": 11, "startHp": 40, "level": 7, "speed": 8,
        "hit_mods": { "mind": -5 },      
    },
    { "name": "Demon Champion", "block": "demon2", 
        "drops": [ "coins", "Greatsword", "Oval potion" ],
        "attack": [10,12], "range": 1, "attackAp": 3, "armor": 12, "startHp": 64, "level": 8, "speed": 8,
        "onHit": (self, pc) => {
            if(random() >= 0.75) {
                setState(pc, STATE_CURSE, 10);
            }
        }, 
        "hit_mods": { "fire": -5, "mind": -5, "electricity": -5 },     
    },
    { "name": "Yggxurantes", "block": "dragon", 
        "drops": [ "coins" ],
        "attack": [5,8], "range": 6, "rangeBlocks": [ "fireball", "fireball" ], "attackAp": 3, "armor": 15, "startHp": 150, "level": 10, "speed": 3,
        "onHit": (self, pc) => {
            if(random() >= 0.75) {
                setState(pc, STATE_PARALYZE, 10);
            }
            if(random() >= 0.75) {
                setState(pc, STATE_CURSE, 10);
            }
            if(random() >= 0.75) {
                setState(pc, STATE_SCARED, 10);
            }
        },
        "hit_mods": { "fire": -10, "mind": -10, "electricity": -10, "acid": -10 },     
    },
    { "name": "Malleus", "block": "malleus", 
        "drops": [ "coins", "Warhammer", "Oval potion", "Tomes of Knowledge" ],
        "attack": [10,15], "range": 1, "attackAp": 4, "armor": 13, "startHp": 100, "level": 9, "speed": 7,
        "hit_mods": { "fire": -10, "mind": -10, "electricity": -10, "acid": -10 },     
    },
    { "name": "Demon Prince", "block": "demon3", 
        "drops": [ "coins", "Lance", "Oval potion" ],
        "attack": [11,14], "range": 1, "attackAp": 3, "armor": 14, "startHp": 80, "level": 9, "speed": 8,
        "onHit": (self, pc) => {
            # there is a chance the character becomes poisoned
            if(random() >= 0.75) {
                setState(pc, STATE_PARALYZE, 10);
            }
            if(random() >= 0.75) {
                setState(pc, STATE_SCARED, 10);
            }
        },  
        "hit_mods": { "fire": -5, "mind": -5, "electricity": -5, "acid": -5 },     
    },
    { "name": "Xurtang Thrall", "block": "alien1", 
        "drops": [ "coins", "Lance", "Oval potion" ],
        "attack": [12,16], "range": 1, "attackAp": 2, "armor": 6, "startHp": 100, "level": 10, "speed": 8,
        "onHit": (self, pc) => {
            # there is a chance the character becomes poisoned
            if(random() >= 0.75) {
                setState(pc, STATE_PARALYZE, 10);
            }
            if(random() >= 0.75) {
                setState(pc, STATE_CURSE, 10);
            }
        },   
        "hit_mods": { "fire": 2, "mind": -10, "electricity": 2, "acid": 2 },     
    },
];

def getHitMod(monster, save) {
    if(save != null && monster.monsterTemplate["hit_mods"] != null) {
        if(monster.monsterTemplate.hit_mods[save] != null) {
            #trace(monster.monsterTemplate.name + " vs " + save + "=" + monster.monsterTemplate.hit_mods[save]);
            return monster.monsterTemplate.hit_mods[save];
        }
    }
    return 0;
}
