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
        if(n.name = "Denir") {
            return {
                "": "Welcome to the Vamir Corner Shop! Let me know if you want to see my $wares|_trade_!"
            };
        }
        if(n.name = "Lola") {
            return {
                "": "I'm Lola, mistress of the Thirsty Vamp - this here tavern. Let me know if you need a $drink|_trade_ or if you want to hear a $gossip.",
                "gossip": () => {
                    n := roll(0, 3);
                    if(n = 0) {
                        return "$Arnel is one my best patrons. He's here every day, 'waiting', he says.";
                    }
                    if(n = 1) {
                        return "I heard that $Alterolan trapped a demon!";
                    }
                    return "They say there are $Gnorks beneath castle Skyforge.";
                },
                "Arnel": "I don't know much about him or what he's waiting for. He used to be a fine swordsman, they say. Want to hear another $gossip?",
                "Gnorks": "They're small humanoids with a penchant for stealing and killing. Nasty little buggers. Would you like to hear another $gossip?",
                "Alterolan": "She is the scholar who lives in the house of Tristen by Lake Orn. Not sure how it happened, but she trapped a demon in her storage room! Want another $gossip?",
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        if(n.name = "Denir") {  
            return [ OBJECT_WEAPON, OBJECT_SUPPLIES, OBJECT_POTION ];
        }
        if(n.name = "Lola") {  
            return [ OBJECT_DRINK, OBJECT_FOOD ];
        }
        return null;
    },
    "onLoot": (self, x, y) => {
        return false;
    },    
    "onDoor": (self, x, y) => {
        return false;
    }

};
