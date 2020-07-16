const events_fenvel = {
    "onEnter": self => {
        gameMessage("Arrived in Fenvel", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Carl") {
            return {
                "": "sdfasdfasd",
            };
        }
        if(n.name = "Morten") {
            return {
                "": "sdfasdfasd",
            };
        }
        if(n.name = "Asile") {
            return {
                "": "sdfasdfasd",
            };
        }
        if(n.name = "Simone") {
            return {
                "": "sdfasdfasd",
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        if(n.name = "Carl") {
            return [ OBJECT_ARMOR, OBJECT_WEAPON ];
        }
        if(n.name = "Asile") {
            return [ OBJECT_FOOD, OBJECT_DRINK ];
        }
        if(n.name = "Simone") {
            return [ OBJECT_SUPPLIES, OBJECT_POTION ];
        }
        return null;
    },
};
