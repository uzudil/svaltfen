const TELEPORTERS_SPIRE1 = [
    [ 37, 67, 26, 46 ],
    [ 27, 54, 37, 57 ],
    [ 53, 54, 43, 57 ],
    [ 43, 67, 54, 46 ],
];

const events_spire1 = {
    "onEnter": self => {
        gameMessage("You entered a dilapidated tower. You get the sense people don't live here anymore, but that doesn't mean it's empty.", COLOR_LIGHT_BLUE);
    },
    "onTeleport": self => {
        return TELEPORTERS_SPIRE1;
    },
    "onLoot": (self, x, y) => {
        if(x = 41 && y = 27) {
            gameMessage("You find a rather large sword, its pomel shaped like a screaming face.", COLOR_GREEN);
            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Demonsbane Sword (+4 vs demon)"]);
            return true;
        }
        return false;
    },        
};
