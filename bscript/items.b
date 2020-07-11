const SLOT_HEAD = "head";
const SLOT_NECK = "neck";
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
    SLOT_NECK,
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

const ITEMS = [
    { "name": "Moldy cheese", "price": 2, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 2), },
    { "name": "Loaf of bread", "price": 3, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 2) },
    { "name": "Roast chicken", "price": 5, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 4) },
    { "name": "Rare steak", "price": 7, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 5) },
    { "name": "Chocolate", "price": 3, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 1) },    

    { "name": "Watery beer", "price": 1, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 1) },
    { "name": "Ogrebreath Ale", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Green wine", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Water", "price": 1, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },

    { "name": "Leather gloves", "level": 1, "price": 3, "type": OBJECT_ARMOR, "slot": SLOT_GLOVE, "ac": 1, },
    { "name": "Leather boots", "level": 2, "price": 4, "type": OBJECT_ARMOR, "slot": SLOT_BOOTS, "ac": 2, },
    { "name": "Leather armor", "level": 3, "price": 12, "type": OBJECT_ARMOR, "slot": SLOT_ARMOR, "ac": 4, },
    { "name": "Traveling cape", "level": 2, "price": 8, "type": OBJECT_ARMOR, "slot": SLOT_CAPE, "ac": 1, },
    { "name": "Leather helm", "level": 1, "price": 7, "type": OBJECT_ARMOR, "slot": SLOT_HEAD, "ac": 2, },

    { "name": "Dagger", "level": 1, "price": 7, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 2, 4 ] },
    { "name": "Small sword", "level": 2, "price": 8, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 3, 5 ] },
    { "name": "Soldier's sword", "level": 3, "price": 15, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 4, 8 ] },
    { "name": "Battle Axe", "level": 3, "price": 16, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 5, 8 ] },
    { "name": "Warhammer", "level": 4, "price": 15, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 5, 8 ] },

    { "name": "Torch", "level": 1, "price": 2, "type": OBJECT_SUPPLIES, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ] },
    { "name": "Lockpick", "level": 1, "price": 3, "type": OBJECT_SUPPLIES },
    { "name": "Rope", "level": 1, "price": 4, "type": OBJECT_SUPPLIES },

    { "name": "Small round potion", "level": 1, "price": 3, "type": OBJECT_POTION, "use": (self, pc) => gainHp(pc, 10) },
    { "name": "Large round potion", "level": 2, "price": 12, "type": OBJECT_POTION, "use": (self, pc) => gainHp(pc, 35) },
];

ITEMS_BY_TYPE := {};
ITEMS_BY_NAME := {};

def initItems() {
    array_foreach(ITEMS, (index, item) => { item["sellPrice"] := max(int(item.price * 0.75), 1); if(ITEMS_BY_TYPE[item.type] = null) {     ITEMS_BY_TYPE[item.type] := []; } ITEMS_BY_TYPE[item.type][len(ITEMS_BY_TYPE[item.type])] := item; ITEMS_BY_NAME[item.name] := item;
    });
}

def getRandomItem(types) {
    type := choose(types);
    return choose(ITEMS_BY_TYPE[type]);
}

def itemInstance(item) {
    return { "name": item.name, "quality": 100, "uses": 0 };
}

def getLoot(level) {
    items := array_filter(ITEMS, item => {
        if(item["level"] != null) {
            return item.level <= level;
        }
        return false;
    });
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
