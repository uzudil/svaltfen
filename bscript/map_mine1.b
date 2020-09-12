const events_mine1 = {
    "onEnter": self => {
        gameMessage("The abandoned halls echo in this empty mine.", COLOR_LIGHT_BLUE);
    },
    "onDoor": (self, x, y) => {
        if(x = 50 && y = 35) {
            gameMessage("The grate won't budge.", COLOR_MID_GRAY);
            return true;
        }
        if(operateSwitch(x, y, 16, 24, 50, 35, 82, 83)) {
            gameMessage("You hear scraping noises from the south-east.", COLOR_GREEN);
        }
        return false;
    },
};
