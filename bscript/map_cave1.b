const events_cave1 = {
    "onEnter": self => {
        gameMessage("This cave's walls are covered in strange runes.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        return null;
    },
    "onLoot": (self, x, y) => {
        if(x = 62 && y = 19) {
            gameMessage("You find a rusty axe with a skull carved into its handle.", COLOR_GREEN);
            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Axe of Undeath (+3 vs undead)"]);
            return true;
        }
        return false;
    },    
};
