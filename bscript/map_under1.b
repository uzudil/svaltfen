const events_under1 = {
    "onEnter": self => {
        gameMessage("The red walls emanate heat. The air smells of sulphur and choking smoke.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Zora" ||  n.name = "Birgen" ||  n.name = "Lena" || n.name = "Menra") {
            return {
                "": "Are you $delivering laboratory supplies to Malleus stranger? Or have you come to $spy on our studies?!",
                "delivering": "Oh good, he has been waiting for you. Just drop the supplies in one of the $labs to the east. Malleus is currently $away but will be back shortly.",
                "labs": "You'll find stone rooms to the east. It's where Malleus is conducting his experiments. If you need to $talk|away to him, he should be back soon.",
                "away": "Malleus has gone to set up the final experiment in the $chapel. He will be back soon.",
                "chapel": "A sacred space surrounded by a sea of lava. You can find $Malleus|away there now, setting up his experiment.",
                "spy": "Talk to me no more spy! I'm off to sound the alarm and summon the demon guard!",
            };
        }
        if(n.name = "Malleus") {
            return {
                "": "I have been waiting for you Fregnar. I must say it took you much less time to get here than I imagined. But it is good to see that events are unfolding according to $plan.",
                "plan": "The Sages of Ashnar had no clue how you were summonned, did they? Small wonder since it was I who called you $back from the dead. You were nothing but a puppet then and so are you a puppet even now.",
                "back": "Oh yes, I animated your sorry remains using the $books you see around you. Why would I do that you may $wonder?",
                "wonder": "Well Fregnar, wonder no more. I summoned you myself because that is what it takes to power up the $tomes|books. Now, thanks to you the power of the Tomes of Knowledge is at my disposal. And speaking of disposal, there is but one small $task that needs completing...",
                "books": "Yes, these are the Tomes of Knowledge you, no doubt, have been sent here to retrieve. I'm afraid I'm going to have to hang on to them a bit longer. But instead of $wondering|wonder about the books, I would focus on what will happen to you now that you're no longer of any use to me.",
                "task": "Oh yes, I'm afraid now that the Tomes of Knowledge are functional, I no longer require your services. Prepare to return to the $grave Fregnar!",
                "grave": () => {
                    # add some help
                    addMonster("demon", 18, 53);
                    addMonster("demon", 18, 48);
                    addMonster("cultist", 22, 53);
                    addMonster("demon", 22, 48);
                    addMonster("cultist", 14, 52);
                    addMonster("demon", 14, 49);
                    addMonster("cultist", 26, 49);
                    addMonster("demon", 26, 52);
                    addMonster("cultist", 19, 44);
                    addMonster("demon", 21, 44);
                    # convert npc to a monster of same block
                    #monsterify(n);
                    gameMessage("Attack, my minions!", COLOR_RED);
                    return null;
                },
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        return null;
    },
    "onLoot": (self, x, y) => {
        if(x = 78 && y = 29) {
            gameMessage("You find large rusty key in this chest.", COLOR_GREEN);
            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Rusty key"]);
            return true;
        }
        if(x = 25 && y = 12) {
            gameMessage("You find large key shaped like a human rib cage.", COLOR_GREEN);
            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Skeleton key"]);
            return true;
        }        
        if(x = 74 && y = 71) {
            gameMessage("You find small cross-shaped key.", COLOR_GREEN);
            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Cross key"]);
            return true;
        }        
        return false;
    },    
    "onDoor": (self, x, y) => {
        if(x = 20 && y = 60 && getGameState("malleus_door") = null) {
            if(array_find_index(player.inventory, invItem => invItem.name = "Rusty key") > -1 && 
                array_find_index(player.inventory, invItem => invItem.name = "Skeleton key") > -1 &&
                array_find_index(player.inventory, invItem => invItem.name = "Cross key") > -1) {
                setGameState("malleus_door", true);
                gameMessage("You use the three keys to unlock the door!", COLOR_GREEN);
                return false;
            } else {
                gameMessage("This door is locked by three heavy locks.", COLOR_MID_GRAY);
            }
            return true;
        }
        return false;
    },
    "getNpcRadius": (self, n) => {
        if(n.name = "Malleus") {
            return 0;
        }
        return 5;
    }
};
