const events_market = {
    "onEnter": self => {
        gameMessage("You arrive at a busy road-side market.", COLOR_LIGHT_BLUE);
    },
     "onConvo": (self, n) => {
        return {
            "": "All are welcome at this market! Let us know what you $need|_trade_!",
        };
    },
    "onTrade": (self, n) => {
        if(n.name = "Morro") {
            return [ OBJECT_SUPPLIES ];
        }
        if(n.name = "Mara") {
            return [ OBJECT_FOOD, OBJECT_DRINK ];
        }
        if(n.name = "Anton") {
            return [ OBJECT_WEAPON, OBJECT_ARMOR ];
        }
        if(n.name = "Zana") {
            return [ OBJECT_POTION ];
        }
        return null;
    },
};
