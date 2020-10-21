const events_norden = {
    "onEnter": self => {
        gameMessage("Your steps echo off high ceilings in this enormous keep.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Merced") {
            return {
                "": "blah blah blah - miners dissapeared / reports of something unnatural that ate them...",
            };
        }
    },
    "onMonsterKilled": (self, monster) => {
    },
};
