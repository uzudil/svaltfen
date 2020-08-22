const events_ardor = {
    "onEnter": self => {
        gameMessage("The dungeon Ardor is beneath the castle Skyforge.", COLOR_LIGHT_BLUE);
    },
    "onDoor": (self, x, y) => {
        if((x = 72 && y = 60) || (x = 72 && y = 64)) {
            gameMessage("The grate won't budge.", COLOR_MID_GRAY);
            return true;
        }
        if(operateSwitch(x, y, 77, 60, 72, 60, 82, 83) || operateSwitch(x, y, 77, 64, 72, 64, 82, 83)) {
            gameMessage("You hear the sound of metal scraping on stone, nearby.", COLOR_GREEN);
        }

        # bridge 
        operateSwitch(x, y, 30, 43, 27, 20, 0, 76);
        if(operateSwitch(x, y, 30, 43, 27, 19, 0, 76)) {
            gameMessage("You hear water splashing, from the north.", COLOR_GREEN);
        }

        return false;
    },

};
