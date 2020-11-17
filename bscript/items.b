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
    { "name": "Moldy cheese", "img": "cheese", "description": "A piece of runny, stinky cheese.", "price": 2, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 2), },
    { "name": "Hard cheese", "img": "cheese", "description": "The hard end of a tasty cheese.", "price": 3, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 3), },
    { "name": "Loaf of bread", "img": "bread", "description": "Some bread that has seen better days.", "price": 3, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 2) },
    { "name": "Hardtack", "img": "bread", "description": "It's tasteless and hard. Better than starvation.", "price": 4, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 5) },
    { "name": "Roast chicken", "img": "chicken", "description": "A fat roasted hen.", "price": 5, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 4) },
    { "name": "Roast duck", "img": "chicken", "description": "A fat roasted duck.", "price": 5, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 4) },
    { "name": "Rare steak", "img": "meat", "description": "A grimy piece of steak you think was cooked.", "price": 7, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 5) },
    { "name": "Fried ribs", "img": "ribs", "description": "Fried pork ribs, generously salted.", "price": 7, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 5) },
    { "name": "Mutton", "img": "mutton", "description": "Mutton. It is as gray as it is tasteless.", "price": 8, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 7) },
    { "name": "Meat Pie", "img": "pie", "description": "A pie filled with savory mystery meat. Despite the smell, the taste is pretty good.", "price": 9, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 8) },
    { "name": "Rice cakes", "img": "rice", "description": "These small rice cakes are slightly sweet.", "price": 5, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 4) },
    { "name": "Lentils", "img": "lentils", "description": "Boiled lentils with a hint of some kind of spice.", "price": 5, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 6) },
    { "name": "Chocolate", "img": "choco", "description": "A small bar of delicious chocolate.", "price": 3, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 1) },    
    { "name": "Smoked meat", "img": "meat", "description": "You're not sure what kind of smoked meat this is.", "price": 6, "type": OBJECT_FOOD, "use": (self, pc) => eat(pc, 6) },    

    { "name": "Watery beer", "img": "beer", "description": "It's flat, warm and pretty much inoffensive. Could just be water.", "price": 1, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 1) },
    { "name": "Coffee", "img": "coffee", "description": "Coffee with a hint of burnt garbage and pipe ash.", "price": 2, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 1) },
    { "name": "Ogrebreath Ale", "img": "beer", "description": "Ale known for being the same color going in and coming back up.", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Sour Beer", "img": "beer", "description": "Sour beer is somewhat of a delicacy. Or maybe just a cooking accident.", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Strong Ale", "img": "beer", "description": "Like the hammer on the label, this will make you quickly forget your troubles.", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },
    { "name": "Green wine", "img": "wine", "description": "Also known as the wine of last resort. Just foul.", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Fragrant Wine", "img": "wine2", "description": "From the grapes of the hills next to lake Orn, this wine is surpringly good.", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Sour Wine", "img": "wine2", "description": "A cheaper relative of Ornian red wine.", "price": 3, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 2) },
    { "name": "Milk", "img": "milk", "description": "A barely spoiled batch of cow milk.", "price": 2, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },
    { "name": "Yoghurt", "img": "milk", "description": "Is it yogurt or just spoiled milk?", "price": 2, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },
    { "name": "Kefir", "img": "milk", "description": "This goatsmilk kefir is filling and tasty.", "price": 2, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },
    { "name": "Mead", "img": "mead", "description": "Honey wine brewed in Fenvel. Tasty in small sips, but overwhelming after a while.", "price": 4, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 4) },
    { "name": "Water", "img": "water", "description": "A mostly clear glass of lake water.", "price": 1, "type": OBJECT_DRINK, "use": (self, pc) => drink(pc, 3) },

    { "name": "Leather gloves", "img": "gloves", "description": "A well used pair of leather work gloves.", "level": 1, "price": 3, "type": OBJECT_ARMOR, "slot": SLOT_GLOVE, "ac": 1, },
    { "name": "Leather boots", "img": "boots", "description": "These leather boots are a tad too small but seem well worn in.", "level": 2, "price": 4, "type": OBJECT_ARMOR, "slot": SLOT_BOOTS, "ac": 2, },
    { "name": "Leather armor", "img": "armor1", "description": "A set of padded leather armor.", "level": 3, "price": 12, "type": OBJECT_ARMOR, "slot": SLOT_ARMOR, "ac": 4, },
    { "name": "Leather helm", "img": "helm1", "description": "A helmet made of leather. It might make you look like a dingus but protects your noggin.", "level": 1, "price": 7, "type": OBJECT_ARMOR, "slot": SLOT_HEAD, "ac": 2, },
    { "name": "Chain gloves", "img": "gloves3", "description": "A gauntlet of interlinked chain.", "level": 2, "price": 10, "type": OBJECT_ARMOR, "slot": SLOT_GLOVE, "ac": 2, },
    { "name": "Chain armor", "img": "armor3", "description": "Torso covering made of chain links.", "level": 4, "price": 18, "type": OBJECT_ARMOR, "slot": SLOT_ARMOR, "ac": 5, },
    { "name": "Steel boots", "img": "boots2", "description": "These heavy boots are made of steel and seem indestructible.", "level": 3, "price": 14, "type": OBJECT_ARMOR, "slot": SLOT_BOOTS, "ac": 3, },
    { "name": "Steel helm", "img": "helm2", "description": "A heavy steel helm to ward off all but the worst blows.", "level": 2, "price": 12, "type": OBJECT_ARMOR, "slot": SLOT_HEAD, "ac": 3, },
    { "name": "Mail gloves", "img": "gloves2", "description": "A war gauntlet of sliding metal plates.", "level": 3, "price": 15, "type": OBJECT_ARMOR, "slot": SLOT_GLOVE, "ac": 3, },
    { "name": "Mail armor", "img": "armor2", "description": "Akin to canned food, it's a tight fit in this full set of mail armor.", "level": 5, "price": 32, "type": OBJECT_ARMOR, "slot": SLOT_ARMOR, "ac": 6, },    
    { "name": "War helm", "img": "helm3", "description": "Sporting the horns of a dead foe, you look proper fearsome wearing this helm.", "level": 3, "price": 20, "type": OBJECT_ARMOR, "slot": SLOT_HEAD, "ac": 4, },    
    { "name": "Platemail", "img": "armor4", "description": "The finest set of sliding plates protect your entire body with this armor.", "level": 6, "price": 50, "type": OBJECT_ARMOR, "slot": SLOT_ARMOR, "ac": 7, },
    { "name": "Ring of Protection", "level": 5, "price": 75, "type": OBJECT_ARMOR, "slot": [ SLOT_RING1, SLOT_RING2 ], "ac": 1, },

    { "name": "Gold crown", "description": "A valuable crown made of gold.", "level": 3, "price": 400, "type": OBJECT_ARMOR, "slot": SLOT_HEAD, "ac": 1, },

    { "name": "Traveling cape", "img": "cape1", "description": "A heavy duty cape to ward off the rain. Also serves as a sleeping bag.", "level": 2, "price": 8, "type": OBJECT_ARMOR, "slot": SLOT_CAPE, "ac": 1, },
    { "name": "Forest cape", "img": "cape2", "description": "A lighter outer layer that helps you blend into the natural environment.", "level": 2, "price": 12, "type": OBJECT_ARMOR, "slot": SLOT_CAPE, "ac": 1, },
    { "name": "Cloud cape", "img": "cape3", "description": "While this cape is made of a thin and light material, it seems to last better than most others.", "level": 3, "price": 22, "type": OBJECT_ARMOR, "slot": SLOT_CAPE, "ac": 2, },

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

    { "name": "Demonsbane Sword", "description": "A rather large sword, its pomel shaped like a screaming face.", "level": 6, "price": 800, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 4, 8 ], "bonus": 4, "bonusVs": "demon" },
    { "name": "Axe of Undeath", "description": "A rusty axe with a skull carved into its handle.", "level": 6, "price": 800, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 5, 8 ], "bonus": 3, "bonusVs": "undead" },
    { "name": "Lance of Aberrations", "description": "A silver lance decorated with a swirl pattern.", "level": 6, "price": 800, "type": OBJECT_WEAPON, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "dam": [ 4, 6 ], "bonus": 3, "bonusVs": "alien" },

    { "name": "Composite Bow", "level": 1, "price": 25, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 2, 4 ], "range": 6 },
    { "name": "Longbow", "level": 2, "price": 50, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 2, 5 ], "range": 6 },
    { "name": "Hunting bow", "level": 2, "price": 42, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 3, 5 ], "range": 6 },
    { "name": "Crossbow", "level": 3, "price": 75, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 2, 6 ], "range": 6 },
    { "name": "Heavy Crossbow", "level": 4, "price": 120, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 3, 6 ], "range": 6 },
    { "name": "Throwing Knife", "level": 2, "price": 60, "type": OBJECT_WEAPON, "slot": SLOT_RANGED, "dam": [ 1, 2 ], "range": 3, "rangeBlocks": [ "knife", "knife2" ] },

    { "name": "Torch", "level": 1, "price": 2, "type": OBJECT_SUPPLIES, "slot": [ SLOT_LEFT_HAND, SLOT_RIGHT_HAND ], "light": 3 },
    { "name": "Lockpick", "level": 1, "price": 3, "type": OBJECT_SUPPLIES, "use": (self, pc) => openLock() },
    { "name": "Rope", "level": 1, "price": 4, "type": OBJECT_SUPPLIES, "use": (self, pc) => escapeCave() },
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

    { "name": "Round potion", "img": "potion1", "description": "A small vial that smells medicinal.", "level": 1, "price": 3, "type": OBJECT_POTION, "use": (self, pc) => gainHp(pc, 10, true) },
    { "name": "Oval potion", "img": "potion2", "description": "A large flask of medicinal smelling liquid.", "level": 1, "price": 12, "type": OBJECT_POTION, "use": (self, pc) => gainHp(pc, 35, true) },
    { "name": "Hazy potion", "img": "potion3", "description": "The vapors from this vial sting the eye.", "level": 1, "price": 6, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_POISON, 0) },
    { "name": "Cloudy potion", "img": "potion4", "description": "The liquid stirs freely in this vial.", "level": 1, "price": 8, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_PARALYZE, 0) },
    { "name": "Mirror potion", "img": "potion5", "description": "Calming scents issue from this vial.", "level": 1, "price": 10, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_CURSE, 0) },
    { "name": "Pooling potion", "img": "potion6", "description": "A dark liquid sloshes reassuringly inside this vial.", "level": 1, "price": 15, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_SCARED, 0) },
    { "name": "Hard potion", "img": "potion7", "description": "A heavy vial of slow moving liquid.", "level": 1, "price": 12, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_SHIELD, 150) },
    { "name": "Radiant potion", "img": "potion8", "description": "A heady scent is apparent with this vial, even with the top on.", "level": 1, "price": 17, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_BLESS, 150) },
    { "name": "Dusty potion", "img": "potion9", "description": "Sniffing this vial fills you with a sense of urgency.", "level": 1, "price": 20, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_ALERT, 150) },
    { "name": "Transparent potion", "img": "potion10", "description": "A colorless, near invisible liquid is in this vial.", "level": 1, "price": 20, "type": OBJECT_POTION, "use": (self, pc) => setState(pc, STATE_INVISIBLE, 150) },

    { "name": "Brass key", "img": "key1", "description": "A key made of brass.", "level": 1, "price": 2, "type": OBJECT_SPECIAL },
    { "name": "Rusty key", "img": "key2", "description": "A rusty, iron key.", "level": 1, "price": 2, "type": OBJECT_SPECIAL },
    { "name": "Skeleton key", "img": "key3", "description": "This key resembles a human rib cage.", "level": 1, "price": 2, "type": OBJECT_SPECIAL },
    { "name": "Cross key", "img": "key4", "description": "A key with a cross shape.", "level": 1, "price": 2, "type": OBJECT_SPECIAL },
    { "name": "Tomes of Knowledge", "img": "book", "description": "These fabled books are clearly magical in nature. You try but can't make out the text.", "level": 1, "price": 1, "type": OBJECT_SPECIAL },
    { "name": "Swirl Key", "img": "key5", "description": "A key made of some swirly stone.", "level": 1, "price": 1, "type": OBJECT_SPECIAL },

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
    ITEMS_BY_NAME["Soft potion"] := ITEMS_BY_NAME["Radiant potion"];
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

def describeItem(name) {
    item := ITEMS_BY_NAME[name];
    if(item = null) {
        return "";
    }
    if(item["description"] != null) {
        return item.description;
    }
    return "";
}
