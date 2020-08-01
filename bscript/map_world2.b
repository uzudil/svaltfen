const events_world2 = {
    "onEnter": self => {
    },
    "onConvo": (self, n) => {
        return null;
    },
    "onTrade": (self, n) => {
        return null;
    },
    "onSecret": (self, x, y) => {
        if(x = 73 && y = 24 && getGameState("quest_xurcelt") = null) {
            return false;
        }
        return true;
    },    
};
