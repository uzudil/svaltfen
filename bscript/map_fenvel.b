const events_fenvel = {
    "onEnter": self => {
        gameMessage("Arrived in Fenvel", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Carl") {
            return {
                "": "Welcome to Carnegen $Keep|keep, stranger. How can I $help you?",
                "keep": "This here keep is named after Lord Carnegen, a great $hero of ancient days.",
                "hero": "Over a thousand years ago he defeated the armies of the underworld. Legends say if you find his $armor, you will be invincible!",
                "armor": "Lord Carnegen's armor is protected by the gods of the Sky! Where it is now, I cannot tell. But if armor is what you're looking for, you should see my $wares|_trade_!",
                "help": "This $keep is much too big for just $Cozz and I. Feel free to rest here for a while. And if armor or weapons is what you're after, let me $know|_trade_!",
                "Cozz": "Cozz is the village cook. He sells some of what he makes. You can find him in the kitchen.",
            };
        }
        if(n.name = "Morten") {
            return {
                "": "Come closer stranger and let me look at you. You $resemble someone I've met before...",
                "resemble": () => {
                    if(getGameState("mark_of_fregnar") = null) {
                        return "My $mistake, pay no mind to the ramblings of an addled mind.";
                    } else {
                        return "Ah I see it now: the mark of Fregnar is upon you! So as Aiden said is true - we are living in a Cursed Year. But still I want to be $sure...";
                    }
                },
                "mistake": "I thought I knew you, but upon closer inspection, I was mistaken.",
                "sure": () => {
                    if(getGameState("nixbeetle_trophy") = null) {                                                
                        return "Yes, the mark of Fregnar is present, but I need to know that you really are a mighty warrior. The $task I have in mind should cause you no trouble.";
                    } else {
                        gameMessage("You should Morten the dead Nixbeetle carapace.", COLOR_GREEN);
                        return "I'm impressed and no longer doubt you worthy of the title Fregnar! If you don't $mind me tagging along, I'd like to $join you on your quest and aide you any way I can.";
                    }
                },
                "task": "A small deed of valor is all I require, to prove that you are this year's Fregnar. If you can defeat a $Nixbeetle, I will doubt your prowess no more.",
                "Nixbeetle": "A fearsome giant vermin they be... Their bodies produce a caustic acid that can melt swords and armor. Bring me proof that you have slain one and prove worthy of being called Fregnar!",
                "mind": "I understand Fregnar. I will be here ready to $join and help out if you should change your mind.",
                "join": () => {
                    gameMessage("Morten joins you as a companion!", COLOR_YELLOW);
                    morten := newChar("Morten", "robes2", 3);
                    # todo: add some equipment/spells/etc
                    player.party[len(player.party)] := morten;
                    removeNpc("Morten");
                    endConvo();
                    saveGame();
                    return "Onward, Fregnar!";
                },
            };
        }
        if(n.name = "Asile") {
            return {
                "": "Stay for a bit stranger. Let me know if my pub can $offer|_trade_ you any food or drink.",
            };
        }
        if(n.name = "Simone") {
            return {
                "": "Step carefully stranger. Many of these $herbs|_trade_ will go into life-saving potions.",
            };
        }
        if(n.name = "Cozz") {
            return {
                "": "Feeling $hungry|_trade_? I cook for only Carl now in Carnegen Keep. Back in the $day this place had more mouths to feed!",
                "day": "Oh yes, the Keep was here to keep all of $Fenvel safe in $times of trouble. But those old days are gone now and only $Carl and I are left.",
                "Carl": "The blacksmith of Carnegen $Keep|day.",
                "Fenvel": "Sure it's a small town, but even a small town needs some stone walls during a $Cursed|times Year.",
                "times": "The evil times come every so often, I'm told. You should speak with Morten, our resident historian about this. He lives outside of the $Keep|day.",
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        if(n.name = "Carl") {
            return [ OBJECT_ARMOR, OBJECT_WEAPON ];
        }
        if(n.name = "Asile" || n.name = "Cozz") {
            return [ OBJECT_FOOD, OBJECT_DRINK ];
        }
        if(n.name = "Simone") {
            return [ OBJECT_SUPPLIES, OBJECT_POTION ];
        }
        return null;
    },
};
