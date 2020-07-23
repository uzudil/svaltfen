const events_ashnar2 = {
    "onEnter": self => {
        gameMessage("You are in the caves below the library at Ashnar.", COLOR_LIGHT_BLUE);
    },
    "onLoot": (self, x, y) => {
        if(x = 55 && y = 4) {
            gameMessage("You find a small, tarnished, brass key.", COLOR_YELLOW);
            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Brass key"]);
            return true;
        }
        return false;
    },
    "onDoor": (self, x, y) => {
        if(x = 52 && y = 35 && getGameState("ashnar_prison") = null) {
            if(array_find_index(player.inventory, invItem => invItem.name = "Brass key") > -1) {
                gameMessage("You use the small brass key to unlock the door!", COLOR_GREEN);
                setGameState("ashnar_prison", true);
                return false;
            } else {
                gameMessage("This door is locked.", COLOR_MID_GRAY);
            }
            return true;
        }
        return false;
    }
};
