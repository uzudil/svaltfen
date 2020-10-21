const events_cave2 = {
    "onEnter": self => {
        gameMessage("This cave seems to be an abandoned mine.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Kwarn") {
            if(getGameState("werebear_dead") = null) {
                return {
                    "": "Go no $further traveler. Leave while you still can!",
                    "further": "We tried to $mine here and look where it got us. There is something $evil that lives at the heart of this cave.",
                    "mine": "My brothers and I wanted to set up a mine here. We made good money selling the ore and we dug deeper and deeper. Eventually we tunneled into the lair of something $evil... We tried to retreat but alas, our $doom was sealed.",
                    "doom": "Behold the bones and corpses of my kin! May it serve as a warning for you to leave while you still can! Venture no further and avoid the $wrath|evil that led to our downfall.",
                    "evil": "There is an ancient rage in these caves that will not rest. It keeps me also bound to this place, to haunt these corridors and re-live the loss of my kin. If you could vanquish this evil, I could finally escape my curse and rest in peace.",
                };
            } else {
                return {
                    "": "I feel a sense of freedom I have not felt in a long time. Thank you for vanquishing the monster in the deep. I can now drift peacefully into the sleep of eons and haunt here no more. Farewell!",
                };
            }
        }
    },
    "onMonsterKilled": (self, monster) => {
        if(monster.monsterTemplate.block = "bear3") {
            setGameState("werebear_dead", true);
        }
    },
};
