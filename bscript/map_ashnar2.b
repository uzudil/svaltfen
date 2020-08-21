const events_ashnar2 = {
    "onEnter": self => {
        if(mapMutation.npcs["Arman"] = null) {
            setMonsterEnabled(42, 64, false);
        }
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

        # the switch operates the grate
        if(x = 34 && y = 76) {
            b := 88;
            if(getBlock(34, 76).block = 108) {
                b := 43;
            }
            setBlock(42, 70, b, 0);
            setGameBlock(42, 70, b);
            gameMessage("You hear the sound of metal scraping on stone, nearby.", COLOR_GREEN);
        }
        return false;
    },
    "onSecret": (self, x, y) => {
        if(x = 25 && y = 35 && getGameState("weapon_quest") = null) {
            return false;
        }
        return true;
    },
    "onConvo": (self, n) => {
        if(n.name = "Arman") {
            return {
                "": "Has Lord $Malleus sent you? I've been waiting for him $here for ages!",
                "here": "Lord $Malleus posted me here to keep those nosy librarians out of our business. As I'm sure you're aware, the stakes are rather high!",
                "Malleus": "What do you mean 'not exactly'? I can't be standing here guarding the $entrance to high-powered alien weaponry for much longer! The librarians are going to figure it out and... Sorry, I'm freaking out here!",
                "entrance": "Yes, it is the entrance to where we keep the... Wait a minute! I thought you said Malleus sent you?! Do you not $know where those stairs lead?",
                "know": "Hmmm, I don't $believe you. I don't think you know, and I can't chance you blabbering about this to someone upstairs...",
                "believe": () => {
                    # convert npc to monster
                    removeNpc(n.name);
                    setMonsterEnabled(42, 64, true);

                    # make some holes in the wall
                    y := 69;
                    while(y < 76) {
                        setBlock(38, y, 43, 0);
                        setGameBlock(38, y, 43);
                        y := y + 1;
                    }

                    gameMessage("Arman becomes enraged!", COLOR_YELLOW);
                    return null;
                },
            };
        }
        return null;
    },
};
