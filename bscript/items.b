const SLOT_HEAD = "head";
const SLOT_ARMOR = "armor";
const SLOT_GLOVE = "glove";
const SLOT_BOOTS = "boots";
const SLOT_LEFT_HAND = "left";
const SLOT_RIGHT_HAND ="right";
const SLOT_RING1 = "ring1";
const SLOT_RING2 = "ring2";
const SLOT_RANGED = "ranged";
const SLOT_CAPE = "cape";
const SLOTS = [
    SLOT_HEAD, 
    SLOT_ARMOR,
    SLOT_GLOVE,
    SLOT_LEFT_HAND,
    SLOT_RIGHT_HAND,
    SLOT_RING1,
    SLOT_RING2, 
    SLOT_BOOTS,
    SLOT_RANGED, 
    SLOT_CAPE
];

const OBJECT_FOOD = "food";
const OBJECT_DRINK = "drink";
const OBJECT_POTION = "potion";
const OBJECT_ARMOR = "armor";
const OBJECT_WEAPON = "weapon";
const OBJECT_SUPPLIES = "supplies";
const OBJECT_SPECIAL = "special";

const OBJECT_TYPES = [ OBJECT_POTION, OBJECT_FOOD, OBJECT_DRINK, OBJECT_SUPPLIES, OBJECT_ARMOR, OBJECT_WEAPON, OBJECT_SPECIAL ];

const ITEMS = [
    { "name": "Moldy cheese", "price": 2, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 2), },
    { "name": "Hard cheese", "price": 3, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 3), },
    { "name": "Loaf of bread", "price": 3, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 2) },
    { "name": "Hardtack", "price": 4, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 5) },
    { "name": "Roast chicken", "price": 5, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 4) },
    { "name": "Roast duck", "price": 5, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 4) },
    { "name": "Rare steak", "price": 7, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 5) },
    { "name": "Fried ribs", "price": 7, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 5) },
    { "name": "Mutton", "price": 8, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 7) },
    { "name": "Meat Pie", "price": 9, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 8) },
    { "name": "Rice cakes", "price": 5, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 4) },
    { "name": "Lentils", "price": 5, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 6) },
    { "name": "Chocolate", "price": 3, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 1) },    
    { "name": "Smoked meat", "price": 6, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 6) },    

    { "name": "Watery beer", "price": 1, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 1) },
    { "name": "Coffee", "price": 2, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 1) },
    { "name": "Ogrebreath Ale", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Sour Beer", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Strong Ale", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },
    { "name": "Green wine", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Fragrant Wine", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Sour Wine", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Milk", "price": 2, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },
    { "name": "Yoghurt", "price": 2, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },
    { "name": "Kefir", "price": 2, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },
    { "name": "Mead", "price": 4, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 4) },
    { "name": "Water", "price": 1, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },

    { "name": "Leather gloves", "level": 1, "price": 3, "type": OBJECT_ARMOR, "slot": SLOT_GLOVE, "ac": 1, },
    { "name": "Leather boots", "level": 2, "price": 4, "type": OBJECT_ARMOR, "slot": SLOT_BOOTS, "ac": 2, },
    { "name": "Leather armor", "level": 3, "price": 12, "type": OBJECT_ARMOR, "slot": SLOT_ARMOR, "ac": 4, },
    { "name": "Leather helm", "level": 1, "price": 7, "type": OBJECT_ARMOR, "slot": SLOT_HEAD, "ac": 2, },
    { "name": "Chain gloves", "level": 2, "price": 10, "type": OBJECT_ARMOR, "slot": SLOT_GLOVE, "ac": 2, },
    { "name": "Chain armor", "level": 4, "price": 18, "type": OBJECT_ARMOR, "slot": SLOT_ARMOR, "ac": 5, },
    { "name": "Steel boots", "level": 3, "price": 14, "type": OBJECT_ARMOR, "slot": SLOT_BOOTS, "ac": 3, },
    { "name": "Steel helm", "level": 2, "price": 12, "type": OBJECT_ARMOR, "slot": SLOT_HEAD, "ac": 3, },
    { "name": "Mail gloves", "level": 3, "price": 15, "type": OBJECT_ARMOR, "slot": SLOT_GLOVE, "ac": 3, },
    { "name": "Mail armor", "level": 5, "price": 32, "type": OBJECT_ARMOR, "slot": SLOT_ARMOR, "ac": 6, },    
    { "name": "War helm", "level": 3, "price": 20, "type": OBJECT_ARMOR, "slot": SLOT_HEAD, "ac": 4, },    
    { "name": "Platemail", "level": 6, "price": 50, "type": OBJECT_ARMOR, "slot": SLOT_ARMOR, "ac": 7, },
    { "name": "Ring of Protection", "level": 5, "price": 75, "type": OBJECT_ARMOR, "slot": [ SLOT_RING1, SLOT_RING2 ], "ac": 1, },

    { "name": "Gold crown", "level": 3, "price": 400, "type": OBJECT_ARMOR, "slot": SLOT_HEAD, "ac": 1, },

    { "name": "Traveling cape", "level": 2, "price": 8, "type": OBJECT_ARMOR, "slot": SLOT_CAPE, "ac": 1, },
    { "name": "Forest cape", "level": 2, "price": 12, "type": OBJECT_ARMOR, "slot": SLOT_CAPE, "ac": 1, },
    { "name": "Cloud cape", "level": 3, "price": 22, "type": OBJECT_ARMOR, "slot": SLOT_CAPE, "ac": 2, },

    { "name": "Small shield", "level": 1, "price": 15, "type": OBJECT_ARMOR, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "ac": 1, },
    { "name": "Kite shield", "level": 2, "price": 32, "type": OBJECT_ARMOR, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "ac": 2, },
    { "name": "Full shield", "level": 3, "price": 40, "type": OBJECT_ARMOR, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "ac": 3, },

    { "name": "Dagger", "level": 1, "price": 7, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 2, 4 ] },
    { "name": "Small sword", "level": 2, "price": 8, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 3, 5 ] },
    { "name": "Soldier's sword", "level": 3, "price": 15, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 4, 8 ] },
    { "name": "Battle Axe", "level": 3, "price": 16, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 5, 8 ] },
    { "name": "Warhammer", "level": 4, "price": 15, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 5, 8 ] },
    { "name": "Morningstar", "level": 4, "price": 14, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 4, 7 ] },
    { "name": "Rapier", "level": 5, "price": 20, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 6, 8 ] },
    { "name": "Lance", "level": 3, "price": 15, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 4, 5 ] },
    { "name": "Short Axe", "level": 3, "price": 16, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 2, 6 ] },
    { "name": "Greatsword", "level": 5, "price": 42, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 6, 9 ] },
    { "name": "Greataxe", "level": 5, "price": 42, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 5, 10 ] },

    { "name": "Demonsbane Sword", "level": 6, "price": 800, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 4, 8 ], "bonus": 4, "bonusVs": "demon" },
    { "name": "Axe of Undeath", "level": 6, "price": 800, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 5, 8 ], "bonus": 3, "bonusVs": "undead" },
    { "name": "Lance of Aberrations", "level": 6, "price": 800, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 4, 6 ], "bonus": 3, "bonusVs": "alien" },

    { "name": "Composite Bow", "level": 1, "price": 25, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 2, 4 ], "range": 6 },
    { "name": "Longbow", "level": 2, "price": 50, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 2, 5 ], "range": 6 },
    { "name": "Hunting bow", "level": 2, "price": 42, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 3, 5 ], "range": 6 },
    { "name": "Crossbow", "level": 3, "price": 75, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 2, 6 ], "range": 6 },
    { "name": "Heavy Crossbow", "level": 4, "price": 120, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 3, 6 ], "range": 6 },
    { "name": "Throwing Knife", "level": 2, "price": 60, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 1, 2 ], "range": 3, "rangeBlocks": [ "knife", "knife2" ] },

    { "name": "Torch", "level": 1, "price": 2, "type": OBJECT_SUPPLIES, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "light": 3 },
    { "name": "Lockpick", "level": 1, "price": 3, "type": OBJECT_SUPPLIES },
    { "name": "Rope", "level": 1, "price": 4, "type": OBJECT_SUPPLIES },
    { "name": "Gold ring", "level": 3, "price": 200, "type": OBJECT_SUPPLIES, "slot": [ SLOT_RING1, SLOT_RING2 ] },
    { "name": "Diamond ring", "level": 4, "price": 500, "type": OBJECT_SUPPLIES, "slot": [ SLOT_RING1, SLOT_RING2 ] },
    { "name": "Emerald ring", "level": 3, "price": 450, "type": OBJECT_SUPPLIES, "slot": [ SLOT_RING1, SLOT_RING2 ] },
    { "name": "Topaz ring", "level": 4, "price": 300, "type": OBJECT_SUPPLIES, "slot": [ SLOT_RING1, SLOT_RING2 ] },
    { "name": "Ruby ring", "level": 4, "price": 450, "type": OBJECT_SUPPLIES, "slot": [ SLOT_RING1, SLOT_RING2 ] },
    { "name": "Large gemstone", "level": 5, "price": 500, "type": OBJECT_SUPPLIES },
    { "name": "Small gemstone", "level": 2, "price": 50, "type": OBJECT_SUPPLIES },
    { "name": "Ancient coins", "level": 3, "price": 400, "type": OBJECT_SUPPLIES },
    { "name": "Gold chains", "level": 3, "price": 350, "type": OBJECT_SUPPLIES },
    { "name": "Silver chains", "level": 3, "price": 250, "type": OBJECT_SUPPLIES },
    { "name": "Ruby pin", "level": 2, "price": 50, "type": OBJECT_SUPPLIES },

    { "name": "Round potion", "level": 1, "price": 3, "type": OBJECT_POTION, "use": (self, pc) => gainHp(pc, 10) },
    { "name": "Oval potion", "level": 1, "price": 12, "type": OBJECT_POTION, "use": (self, pc) => gainHp(pc, 35) },
    { "name": "Hazy potion", "level": 1, "price": 6, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_POISON, 0) },
    { "name": "Cloudy potion", "level": 1, "price": 8, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_PARALYZE, 0) },
    { "name": "Mirror potion", "level": 1, "price": 10, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_CURSE, 0) },
    { "name": "Pooling potion", "level": 1, "price": 15, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_SCARED, 0) },
    { "name": "Soft potion", "level": 1, "price": 12, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_SHIELD, 150) },
    { "name": "Hard potion", "level": 1, "price": 17, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_BLESS, 150) },
    { "name": "Dusty potion", "level": 1, "price": 20, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_ALERT, 150) },
    { "name": "Transparent potion", "level": 1, "price": 20, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_INVISIBLE, 150) },

    { "name": "Brass key", "level": 1, "price": 2, "type": OBJECT_SPECIAL },
    { "name": "Rusty key", "level": 1, "price": 2, "type": OBJECT_SPECIAL },
    { "name": "Skeleton key", "level": 1, "price": 2, "type": OBJECT_SPECIAL },
    { "name": "Cross key", "level": 1, "price": 2, "type": OBJECT_SPECIAL },
    { "name": "Tomes of Knowledge", "level": 1, "price": 1, "type": OBJECT_SPECIAL },
    { "name": "Swirl Key", "level": 1, "price": 1, "type": OBJECT_SPECIAL },

    { "name": "Ring of Light", "level": 1, "price": 2, "type": OBJECT_SPECIAL, "slot": [ SLOT_RING1, SLOT_RING2 ], "light": 3, "lightLife": -1 },    
];

ITEMS_BY_TYPE := {};
ITEMS_BY_NAME := {};
ALL_ITEMS := [];

def initItem(item, bonus, saveState, saveName) {
    d := copy_map(item);
    if(d["level"] = null) {
        d["level"] := 1;
    }
    d["bonus"] := bonus;
    if(bonus > 0) {
        if(item["bonusVs"] != null) {
            d["name"] := d["name"] + " (+" + bonus + " vs " + item["bonusVs"] + ")";
        } else {
            d["name"] := "+" + bonus + " " + d["name"];
        }
        d["level"] := d["level"] + 2 * bonus;
        d["price"] := d["price"] * (1 + bonus);
    }
    d["sellPrice"] := max(int(d.price * 0.75), 1); 

    d["save"] := {};
    if(saveState != null) {
        d["save"][saveState] := bonus * 5;
        d["name"] := d["name"] + " " + saveName;
        d["level"] := d["level"] + bonus;
        d["price"] := d["price"] * (1 + bonus);
    }

    if(ITEMS_BY_TYPE[d.type] = null) {
        ITEMS_BY_TYPE[d.type] := []; 
    } 
    ITEMS_BY_TYPE[d.type][len(ITEMS_BY_TYPE[d.type])] := d; 
    ITEMS_BY_NAME[d.name] := d;
    ALL_ITEMS[len(ALL_ITEMS)] := d;
}

def initItems() {
    saves := {};
    saves[STATE_POISON] := "of Antivenom";
    saves[STATE_PARALYZE] := "of Freedom";
    saves[STATE_CURSE] := "of Blessing";
    saves[STATE_SCARED] := "of the Mind";

    array_foreach(ITEMS, (index, item) => { 
        bonus := item["bonus"];
        if(bonus = null) {
            bonus := 0;
        }
        initItem(item, bonus, null, null);
        # make magic armor/weapons
        if(item["bonus"] = null && (item.type = OBJECT_ARMOR || item.type = OBJECT_WEAPON)) {
            # create +1, +2 magic versions also
            initItem(item, 1, null, null);
            initItem(item, 2, null, null);

            # versions with extra protection
            array_foreach(keys(saves), (i, save) => {
                initItem(item, 1, save, saves[save]);
                initItem(item, 2, save, saves[save]);
            });
        }
    });

    # an earlier misspelling
    ITEMS_BY_NAME["Greatsaxe"] := ITEMS_BY_NAME["Greataxe"];
}

def getRandomItem(types, level) {
    type := choose(types);
    return choose(array_filter(ITEMS_BY_TYPE[type], item => item.level <= level));
}

def itemInstance(item) {
    lightLife := STEPS_PER_HOUR * 4;
    if(item["lightLife"]) {
        lightLife := item.lightLife;
    }
    return { "name": item.name, "life": 10 + item.level * 12, "lightLife":  lightLife };
}

def getLoot(level) {
    items := array_filter(ALL_ITEMS, item => item.level <= level && item.type != OBJECT_SPECIAL);
    n := roll(0, 3);
    if(n > 0) {
        while(n >= 0) {
            item := choose(items);
            gameMessage("You find " + item.name + "!", COLOR_GREEN);
            player.inventory[len(player.inventory)] := itemInstance(item);
            n := n - 1;
        }
    }
}
