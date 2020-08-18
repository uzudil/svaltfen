const events_vamir = {
    "onEnter": self => {
        gameMessage("The quaint village of Vamir.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Arnel") {
            return {
                "": "The wandering light has shown me the $truth. One more $drink for the road!",
                "truth": () => {
                    if(getGameState("mark_of_fregnar") = null) {
                        return "Yet the light is muddled and so is the truth. Back into the $bottle|drink I go...";
                    } else {
                        return "One does not often see the mark of the Fregnar in this part of the world! Allow me to $assist you on your quest Fregnar!";
                    }
                },
                "drink": "I'm no common drunk, no sire! I'll have you know I was a master swordsman in my day and I can still show you a trick or two given the right cause.",
                "assist": "I you are $willing to journey with a master swordsman with a slight drinking problem, I'm an your man! But I understand if it's too $much to ask.",
                "much": "No problem Fregnar. If you ever change your mind, you know where to find me.",
                "willing": () => {
                    joinParty(n, 6);
                    return "Onward, Fregnar!";
                },
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        return null;
    },
    "onLoot": (self, x, y) => {
        return false;
    },    
    "onDoor": (self, x, y) => {
        return false;
    }

};
