const TOMES_ASHNAR = [
    [ 38, 63 ],
    [ 38, 66 ], 
    [ 42, 66 ],
    [ 42, 63 ],
];

const events_ashnar = {
    "onEnter": self => {
        gameMessage("You arrive at the Library of Sages at Ashnar", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Marja") {
            return {
                "": "Welcome to the Sages' Library at Ashnar, strager! Let me know if you'd to hear about the $library or the Order of the $sages.",
                "library": "The library was $built over a thousand years ago, for an unknown purpose. Since then, the $sages took over its management and it now houses the largest collection of $books in all of Svaltfen.",
                "built": "Originally the building was quite small, but over the years, sections were $added, $converted or let to decay. It now has sections devoted to $books and learning, as well as a pub and completely $wild|decay sections that people avoid.",
                "added": "The pub and the $sages quarters are examples of sections that were constructed recently. Then there are $converted and much $older|decay parts as well.",
                "converted": "Did you know the $library also has a vast basement? Originally meant to house supplies, it now contains tomes deemed too $dangerous, as well as the ruins of an unused $prison|decay.",
                "dangerous": "Yea, some $books contain magics, or information not suitable for most readers. If you value your sanity, you will not go looking for these tomes. Also stay away from the $ruined|decay section of the $library.",                
                "decay": "Over the centuries, some areas of the $library became abandoned. Sometimes due to lack of use, sometimes for other reasons. These $places now house other, dangerous creatures.",
                "places": "It has been reported that the entire southwest section of the $library building has collapsed. Weeds grow over it and giant bats have been terrorizing our scholars there. Then of course there is the unconfirmed $rumor of Valgraat...",
                "rumor": "Oh yes, everyone here is familiar with rumors of the undead wondering the halls of Valgraat prison. The prison is located in the $library $basement|converted. It was only used briefly and then abandoned. If you can $find the key, you can see the ruins for yourself.",
                "find": "After a while the $prison|rumor became unused and later abandoned. The place was locked and forgotten. Where the key went is anyone's guess. Personally, I think one of the $sages has it.",
                "sages": "The $library is managed by the Order of Sages. They're keepers of all knowledge in Svaltfen. The sages convene in a secret part of the library, only they know how to $access.",
                "access": "They use their magic to teleport in there. There is no gateway connecting their sanctum with the rest of the $building|library. Or at least, no $path, you'd want to take willingly...",
                "path": "Well, officially, the only way in or out of the sages' sanctum is via magic, but... Some say, the real reason why $Valgraat|rumor is kept locked, is because the ruined innards of that unhallowed dungeon still contains a path to the sages' sanctum.",
                "books": "As the largest library in Svaltfen, our collection of tomes is vast and quite priceless. Browse them at your leisure, at no charge, just avoid the $forbidden|dangerous section. Or ask the $sages for assitence, if you can find them.",
            };
        }
        if(n.name = "Hassam") {
            return {
                "": "Welcome to the Last $Chapter, the $library $pub. What will you $have|_trade_ scholar?",
                "Chapter": "It's a clever play on $words|pub, you see? Since we're in the $library and... oh ok, you get it.",
                "pub": "Many scholars visit here to hide behind a mug of ale while they ruminate on their $problems. Some say $drinking|_trade_ helps coming up with creative $solutions.",
                "solutions": "I'm afraid, I can't help with your problems. I have $plenty|problems of my own!",
                "problems": "Speaking of problems, the other day I was $attacked by bats, on my way to work. It happened just south of here in the ruined section of $library.",
                "attacked": "Durring the scuffle, I managed to lose my ring... I'd give $anything to get it back!",
                "anything": () => {
                    if(getGameState("hassam_ring") = null) {
                        return "Well, let say I will give you what I made from tips from the past month. What do you $say? Will you find my ring for me?";
                    } else {
                        if(getGameState("hassam_happy") = null) {
                            gameMessage("You give Hassam his ring back.", COLOR_GREEN);
                            setGameState("hassam_happy", true);
                            player.coins := player.coins + 100;
                            return "Well, look at that! I'm forever in your debt stranger for returning my ring! Please take this meager sum as a token of my thanks.";
                        } else {
                            return "Ah yes, thank you again for returning my ring, my friend. As always, my $store|_trade_ is open to you at a discount.";
                        }
                    }
                },
                "say": "It's a simple gold band. Nothing much, but has a ...uh sentimental value to me. Please let me know if you find it!",
                "library": "The library is an ancient $building. I myself know only a little of its $history... But talk to Marja at the front desk to learn more!",
                "building": "The $library building is huge with some sections completely in ruin. Watch out for $monsters|problems if you venture there. Other parts of the building contains books, as you'd expect. Then there's also the $downstairs.",
                "downstairs": "The vast underground section of library has some odd $books|library and old ruins of what used to be a prison! No one goes there these days - it's spooky!",
                "history": "The $library is maintained by the four sages these days. I think they have a secret meeting place somewhere in the middle of the $building, though I have never seen any doors leading there.",
            };
        }
        if(n.name = "Meln") {
            return {
                "": "I carry only the finest weapons and amor on this side of the Grunvalt mountains! Would you care to see my $wares|_trade_?",
            };
        }
        if(n.name = "Zil") {
            return {
                "": "Look no further if you need potions or supplies! Shall we $trade|_trade_?",
            };
        }
        if(n.name = "Aiden") {
            return {
                "": "It is good to see you again, Fregnar. But do not waste your time on me, let the $others describe their plan.",
                "others": "The four of us are the Order of Sages: Marta, Lynil, Zentus and I. You can always either find me here, or back in my home. Hurry and talk to the other sages.",
            };
        }
        if(n.name = "Marta" || n.name = "Lynil" || n.name = "Zentus") {
            return {
                "": "As Aiden says: the $Fregnar approaches and thus the time to act is near. But, let us know if you require $healing|_heal_, Fregnar.",
                "Fregnar": () => {
                    if(getGameState("ectalius_off") = true) {
                        return "With the destruction of the aliens' weapon, you have ensured the $safety of Svaltfen for now. You have done well Fregnar.";
                    } else {
                        tomes := array_find_index(player.inventory, i => i.name = "Tomes of Knowledge");
                        if(tomes = -1) {
                            if(getGameState("tomes_returned") = true) {
                                return "We have $consulted|consult the sacred tomes. Thank you again Fregnar for your valiant deed in returning our books!";
                            } else {
                                return "Aiden says you are the Fregnar of this Cursed Year. And yes, we feel $this|time also. Someone else, we know not who, called you back to life. However, that mystery must wait as we have another $problem|see.";
                            }
                        } else {
                            del player.inventory[tomes];
                            array_foreach(TOMES_ASHNAR, (i, pos) => {
                                setBlock(pos[0], pos[1], 80, 0);
                                setGameBlock(pos[0], pos[1], 80);
                            });
                            setGameState("tomes_returned", true);
                            saveGame();
                            return "I see you have succeeded and brought the Tomes of Knowledge back with you. Let us $consult the sacred books. You have done a great deed, Fregnar!";
                        }
                    }
                },
                "time": "We are impressed by your progress Fregnar. You must indeed be a great warrior to have made it this far. However, as you can $see, there is more to be done.",
                "see": "These empty plinths, that you see here, just last week supported the four Tomes of Knowledge. Without the $books we cannot know how to fight the Cursed Year.",
                "books": "You see the tomes aren't ordinary books. Their magic comes directly from the power of Mittelurgald, the lord of Frehyen. The pages of these books are empty until the crisis of a Cursed Year, when they $reveal what is expected of us and you, the Fregnar.",
                "reveal": "But this year, besides the unconventional summoning of the $Fregnar, the greater problem is that the books are gone! We cannot sense what became of them. Therefore, as your first task, you must $search all of Svaltfen until the tomes are found.",
                "search": "Yes, your quest seems daunting, but you will not go alone. You already possess the Mark of Fregnar which lets our $agents know to aid you throught the land.",
                "agents": "Just like you found Morten, others will aid you in your cause when you meet them. We don't have much to give you but let our $magics help you on your way.",
                "magics": () => {
                    if(getGameState("enhanced_heal") = null) {
                        gameMessage("You gain Enhanced Healing.", COLOR_GREEN);
                        setGameState("enhanced_heal", true);
                    }
                    setGameState("quest_books", true);
                    return "On your journey, you will face many enemies. Using our skills, we can accelerate your natural ability to heal. Go forth now and return to us when you have found the four Tomes of Knowledge.";
                },
                "consult": "Even after reading what the Tomes say much remains shrouded about the $future. We have learned about Malleus and his plans to use an alien weapon to enslave Svaltfen and the other realms.",
                "future": "The books are vague about the weapon and its $location. We however, know now for certain that the danger posed by this weapon is reason for this Cursed Year. We are all in great danger as long as it remains in Svaltfen.",
                "location": () => {
                    setGameState("weapon_quest", true);
                    return "For your final task Fregnar, we ask you to go forth and destroy the weapon the alien $visitors left behind. All the books say about its location is: '...on the shores of a dark river, the path lies among the stones...'.";
                },
                "visitors": "Not much is known about the aliens who landed in metal sky-pods so long ago. Legends say they were fierce and merciless. None know why they came and why they left. Today, only the ruins of their technology remains, $scattered|location about the land.",
                "safety": "Thanks to your heroic actions, this Cursed Year has come to an end. As a reward, take your time Fregnar to wrap up your affairs. Explore the far reaches of Svaltfen and come back to us when you are $ready to return to rest again.",
                "ready": "You may not be aware but Fregnar heroes who thwart a Cursed Year are elevated to the status of Frehyen where they live ever on. The choice of $sky or $earth Frehyen is open to you.",
                "sky": "So be it. Are you sure you $wish|wish_sky to end your adventures in Svaltfen and ascend to become one of the Frehyen of the Skies? You may also still $change|ready your mind.",
                "earth": "So be it. Are you sure you $wish|wish_earth to end your adventures in Svaltfen and descend to become one of the Frehyen of the Underworld? You may also still $change|ready your mind.",
                "wish_sky": () => {
                    setGameState("game_win", "sky");
                    mode := "win";
                    return null;
                },
                "wish_earth": () => {
                    setGameState("game_win", "earth");
                    mode := "win";
                    return null;
                },
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        if(n.name = "Hassam") {
            return [ OBJECT_FOOD, OBJECT_DRINK ];
        }
        if(n.name = "Meln") {
            return [ OBJECT_ARMOR, OBJECT_WEAPON ];
        }
        if(n.name = "Zil") {
            return [ OBJECT_POTION, OBJECT_SUPPLIES ];
        }
        return null;
    },
    "onLoot": (self, x, y) => {
        if(x = 32 && y = 51) {
            gameMessage("At the bottom of the barrel, you find a small gold ring!", COLOR_GREEN);
            setGameState("hassam_ring", true);
            #player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Brass key"]);
            return true;
        }
        return false;
    },    
};
