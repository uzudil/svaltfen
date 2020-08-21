const events_weapon = {
    "onEnter": self => {
        gameMessage("You emerge on a rocky plain with mountains on all sides. The air smells faintly of herbs you can't quite recognize.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        return null;
    },
    "onTrade": (self, n) => {
        return null;
    },
    "onSecret": (self, x, y) => {
        return true;
    },    
};
