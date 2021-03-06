def randomBlockOfType(type) {
    bb := array_filter(blocks, b => b.type = type);
    return bb[random() * len(bb)];
}

def initBlocks() {
    i := 0;
    while(i < len(blocks)) {
        blocks[i]["index"] := i;

        # default values
        if(blocks[i]["type"] = null) {
            blocks[i]["type"] := blocks[i].img;
        }
        if(blocks[i]["isEdge"] = null) {
            blocks[i]["isEdge"] := false;
        }
        if(blocks[i]["blocking"] = null) {
            blocks[i]["blocking"] := false;
        }
        if(blocks[i]["light"] = null) {
            blocks[i]["light"] := blocks[i]["blocking"];
        }        
        if(blocks[i]["color"] = null) {
            blocks[i]["color"] := COLOR_MID_GRAY;
        }

        i := i + 1;
    }
}

def getBlockIndexByName(name) {
    return array_find_index(blocks, b => b.img = name);
}

blocks := [
    { "img": "water", "blocking": true, "color": COLOR_DARK_BLUE, "light": false },
    { "img": "grass", "color": COLOR_GREEN },
    { "img": "coast", "type": "edge", "isEdge": true, "color": COLOR_BROWN },
    { "img": "coastcorner", "type": "corner", "isEdge": true, "color": COLOR_BROWN }, 
    { "img": "coastturn", "type": "turn", "isEdge": true, "color": COLOR_BROWN }, 
    { "img": "mtn5", "type": "mountain", "blocking": true, "color": COLOR_MID_GRAY }, 
    { "img": "mtn3", "type": "mountain", "blocking": true, "color": COLOR_WHITE }, 
    { "img": "mtn4", "type": "hill", "color": COLOR_WHITE },
    { "img": "road1", "type": "roadend", "color": COLOR_DARK_GRAY },
    { "img": "road2", "type": "road2", "color": COLOR_DARK_GRAY },
    { "img": "road3", "type": "road3", "color": COLOR_DARK_GRAY },
    { "img": "road4", "type": "road4", "color": COLOR_DARK_GRAY },
    { "img": "road5", "type": "road", "color": COLOR_DARK_GRAY },
    { "img": "treesm", "type": "tree-small", "color": COLOR_TEAL },
    { "img": "treesm2", "type": "tree-small", "color": COLOR_TEAL },
    { "img": "castle", "color": COLOR_RED }, 
    { "img": "swamp", "color": COLOR_GREEN }, 
    { "img": "village", "color": COLOR_RED }, 
    { "img": "cave", "color": COLOR_RED }, 
    { "img": "fighter1", "type": "fighter" }, 
    { "img": "brick2", "type": "brick", "blocking": true, "color": COLOR_RED }, 
    { "img": "brick", "type": "brickdoor", "color": COLOR_RED }, 
    { "img": "space", "type": "space", "color": COLOR_BLACK }, 
    { "img": "floor1", "color": COLOR_BROWN }, 
    { "img": "floor2", "color": COLOR_LIGHT_GRAY }, 
    { "img": "brick3", "type": "brickgray", "blocking": true, "color": COLOR_MID_GRAY }, 
    { "img": "brick4", "type": "brickdoorgray", "color": COLOR_MID_GRAY }, 
    { "img": "cand", "type": "candolabra" }, 
    { "img": "chair" }, 
    { "img": "tab1", "blocking": true, "light": false }, 
    { "img": "tab2", "blocking": true, "light": false }, 
    { "img": "car1", "color": COLOR_RED }, 
    { "img": "car2", "color": COLOR_RED }, 
    { "img": "bed", "color": COLOR_TEAL }, 
    { "img": "bed2", "color": COLOR_TEAL }, 
    { "img": "fire1", "blocking": true, "light": false, "color": COLOR_TEAL }, 
    { "img": "oak", "blocking": true, "color": COLOR_TEAL },     
    { "img": "stairs", "type": "stairs-down", "color": COLOR_RED },     
    { "img": "stairs2", "type": "stairs-up", "color": COLOR_RED }, 
    { "img": "earth1", "type": "earth", "blocking": true, "color": COLOR_BROWN }, 
    { "img": "earth2", "type": "earthside", "blocking": true, "color": COLOR_BROWN }, 
    { "img": "earth3", "type": "earthcorner", "blocking": true, "color": COLOR_BROWN }, 
    { "img": "earth4", "type": "earthturn", "blocking": true, "color": COLOR_BROWN }, 
    { "img": "earthfloor", "color": COLOR_BLACK }, 
    { "img": "door1", "type": "doorclosed1", "blocking": true, "color": COLOR_BROWN, "nextState": "door2" }, 
    { "img": "door2", "type": "dooropen1", "blocking": false, "color": COLOR_BROWN, "nextState": "door1" }, 
    { "img": "gate", "color": COLOR_BROWN }, 
    { "img": "treesm3", "type": "tree-small-dense", "blocking": true, "color": COLOR_TEAL }, 
    { "img": "man1" }, 
    { "img": "man2" }, 
    { "img": "man3" }, 
    { "img": "man4" }, 
    { "img": "woman1" }, 
    { "img": "woman2" }, 
    { "img": "woman3" }, 
    { "img": "wood1", "blocking": true, "color": COLOR_BROWN }, 
    { "img": "robes", "type": "robes1" }, 
    { "img": "robes2" }, 
    { "img": "sign_inn", "blocking": true, "color": COLOR_BROWN, "light": false }, 
    { "img": "sign_arm", "blocking": true, "color": COLOR_BROWN, "light": false }, 
    { "img": "sign_store", "blocking": true, "color": COLOR_BROWN, "light": false }, 
    { "img": "chest", "blocking": true, "color": COLOR_BROWN, "light": false }, 
    { "img": "barrel", "blocking": true, "color": COLOR_BROWN, "light": false }, 
    { "img": "barrel2", "blocking": true, "color": COLOR_BROWN, "light": false }, 
    { "img": "tab3", "blocking": true, "color": COLOR_BROWN, "light": false }, 
    { "img": "fire" }, 
    { "img": "bones" }, 
    { "img": "bones2" }, 
    { "img": "rat" }, 
    { "img": "blood" }, 
    { "img": "skeleton" }, 
    { "img": "bat" }, 
    { "img": "books", "blocking": true, "light": false }, 
    { "img": "ghost" }, 
    { "img": "beetle" }, 
    { "img": "fence", "blocking": true, "light": false }, 
    { "img": "bridge" }, 
    { "img": "sign_heal", "blocking": true, "color": COLOR_BROWN, "light": false }, 
    { "img": "skeleton2" },     
    { "img": "pedestal", "blocking": true, "light": false },
    { "img": "pedestal-book", "blocking": true, "light": false },
    { "img": "lava", "blocking": true, "light": false },
    { "img": "grate1", "type": "grateclosed1", "blocking": true, "light": false, "color": COLOR_BROWN, "nextState": "grate2" }, 
    { "img": "grate2", "type": "grateopen1", "blocking": false, "color": COLOR_BROWN, "nextState": "grate1" }, 
    { "img": "rocks", "blocking": true },
    { "img": "shroom" },
    { "img": "plant1" },
    { "img": "plant2" },
    { "img": "fence2", "blocking": true, "light": false },     
    { "img": "candles" },
    { "img": "tomb", "blocking": true, "light": false },
    { "img": "tomb2", "blocking": true, "light": false },
    { "img": "fountain", "blocking": true },
    { "img": "roots", "blocking": true, "color": COLOR_TEAL },     
    { "img": "vegwar" },
    { "img": "xurcelt" },
    { "img": "gnork" },
    { "img": "slime1" },
    { "img": "red1", "blocking": true, "color": COLOR_RED }, 
    { "img": "red2", "blocking": true, "color": COLOR_RED }, 
    { "img": "red3", "blocking": true, "color": COLOR_RED }, 
    { "img": "red4", "blocking": true, "color": COLOR_RED }, 
    { "img": "demon" },
    { "img": "cultist" },
    { "img": "malleus" },
    { "img": "lab" },
    { "img": "robes3" },
    { "img": "demon2" },
    { "img": "switch1", "blocking": true, "color": COLOR_YELLOW, "nextState": "switch2" }, 
    { "img": "switch2", "blocking": true, "color": COLOR_YELLOW, "nextState": "switch1" },     
    { "img": "redgate", "color": COLOR_BROWN }, 
    { "img": "demon3" },    
    { "img": "teleporter", "color": COLOR_LIGHT_BLUE }, 
    { "img": "ruin1", "blocking": true, "light": false },
    { "img": "ruin2", "blocking": true, "light": false },
    { "img": "gun1", "blocking": true, "light": false },
    { "img": "gun2", "blocking": true, "light": false },
    { "img": "gun3", "blocking": true, "light": false },
    { "img": "ctrl1", "blocking": true, "light": false },
    { "img": "alien1" },
    { "img": "earthfl2", "color": COLOR_BLACK },    
    { "img": "ctrl2", "blocking": true, "light": false },
    { "img": "caravan" },
    { "img": "arrow" },
    { "img": "gnorka" },
    { "img": "skeletona" },
    { "img": "acid" },
    { "img": "demona" },
    { "img": "temple" },
    { "img": "draconian" },
    { "img": "dragon" },
    { "img": "struts", "blocking": true, "light": false },
    { "img": "rocks2" },
    { "img": "fireball" }, 
    { "img": "arnel" }, 
    { "img": "morten" }, 
    { "img": "rosa" }, 
    { "img": "vbat" }, 
    { "img": "force", "blocking": true, "light": false },    
    { "img": "bear2" }, 
    { "img": "cave2", "color": COLOR_WHITE },    
    { "img": "bear3" }, 
    { "img": "locked", "blocking": true },
    { "img": "alien2" },
];
