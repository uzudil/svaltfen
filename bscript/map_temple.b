const events_temple = {
    "onEnter": self => {
        gameMessage("You arrive at a serene road-side temple.", COLOR_LIGHT_BLUE);
    },
     "onConvo": (self, n) => {
        return {
            "": "All are welcome at this temple! Let us know if you need $healing|_heal_! We also trade in $potions|_trade_",
        };
    },
    "onTrade": (self, n) => {
        return [ OBJECT_POTION ];
    },
};
