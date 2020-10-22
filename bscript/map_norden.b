const events_norden = {
    "onEnter": self => {
        gameMessage("Your steps echo off high ceilings in this enormous keep.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Merced") {
            return {
                "": "Welcome traveler to the $once|woe glorious castle Norden. Sadly lacking these days of our fabled festive spirit. A $woe dwells here now, in the halls once filled with light and laughter.",
                "woe": "A recent $tragedy keeps our halls quiet. Were it not for the vicious $rumors to fray what is left of our dignity, I pray alone in my halls for a safe resolution to all involved.",
                "tragedy": "Our best miners, a pair of brothers, have left on an $expedition and failed to return. Alas, a common fate of miners but in this case what befell them is truly a $horror.",
                "expedition": "They left about a month ago to venture south-west, having heard tales of a cave, rich with precious ore. They have not returned, and I fear the $worst|horror.",
                "horror": "My sources tell me of an attack in the deep... The miners were possibly ambushed by something they encountered while plying their craft. If someone could find out what $happened, I'd be grateful.",
                "happened": () => {
                    if(getGameState("werebear_dead") = null) {
                        return "You volunteer to travel to this cave and investigate? You have my gratitude already stranger! May luck be on your side!";
                    } else {
                        if(getGameState("werebear_reward") = null) {
                            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["+2 Battle Axe of the Mind"]);
                            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Topaz ring"]);
                            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Ruby pin"]);
                            setGameState("werebear_reward", true);
                            gameMessage("Lord Merced hands you gifts!", COLOR_GREEN);
                            return "Attacked by an undead monster? And you met the ghost of one of the slain miners? You have my eternal gratitude for getting me these news. Take these items as a token of my appreciation!";                            
                        } else {
                            return "You have my eternal gratitude for getting me these news, but leave now so I can mourn the loss of my kin in peace. Farewell stranger and thank you.";
                        }
                    }
                },
                "rumors": "Anger me not by listening to this insipid yarn! The knave who told you these tales of fantasy has clearly overstayed his welcome at Norden! Begone stranger!",
            };
        }
        if(n.name = "Zoltus") {
            return {
                "": "Oh, how we miss $Martos|miners and his brother $Xar|miners. These $halls are quiet without them and our days filled with woe.",
                "halls": "You are standing in the famed beer-hall of castle Norden! Once home to heroes and $miners cavorting until the wee hours of the morning. These days the hall is quiet and no one wants to celebrate.",
                "miners": "About a month ago our best miners, the brothers Martos and Xar left to look for ore in the caves to the south-west. They never returned and there are $rumors that an awful fate befell on them!",
                "rumors": "Don't tell Lord $Merced that I told you, but... the rumors say that something unnatural attacked our $miners in the caves. An ancient evil that slept for eons under the earth!",
                "Merced": "Lord Merced is the ruler of castle Norden. You can find him in his halls to the north. Whatever you do, don't mention the $rumors about the fate of our $miners!",
            };
        }
        if(n.name = "Alaster") {
            return {
                "": "If you are in need of $healing|_heal_, let me know. I am Alaster, master healer and spiritualist, currently at the service of Lord $Merced. Since the $tragic disappearance of Martos and Xar, I've been pondering the fragility of human existence.",
                "Merced": "Lord Merced is the ruler of castle Norden. You can find him in his halls to the north.",
                "tragic": "The two brothers were miner who left on an expedition and never returned. Alas, if only I could have offered my $services|_heal_ they may yet be alive!",
            };
        }
        if(n.name = "Adel") {
            return {
                "": "This place has not been the $same since Martos and Xar disappeared about a month ago. Lord $Merced would give anything to have news of them!",
                "Merced": "Lord Merced is the ruler of castle Norden. You can find him in his halls to the north.",
                "same": "A pair of brothers, both miners, who left to explore some cave. Rumor has it they were attacked by something bad... maybe a $demon!",
                "demon": "Well I don't know for sure if it was a demon or not, but maybe $Sandius knows... it's his area of research after all.",
                "Sandius": "A visiting scholar who lives in the tower. He came here just before the $calamity|same and now can't find a way to leave.",
            };
        }
        if(n.name = "Sandius") {
            if(getGameState("werebear_reward") = null) {
                return {
                    "": "Unless you are here to grant me $leave of this place, bother me not! I'm still fairly busy, despite the fact that I must now do my research from $jail.",
                    "leave": "Ah, I see you are not here to let me go. Of course. If only $Merced would get some $news of his lost miners, I could finally go home!",
                    "jail": "You see, I was contracted to copy a rare volume on the organization and reproduction of $demons, right before those $miners disappeared. Now the entire castle has shut down, and I'm unable to leave!",
                    "miners": "Talk to $Merced about that if you want to know more.",
                    "Merced": "He is the lord of castle Norden. His room is to the east of here.",
                    "news": "If you found news about the lost miners, you should tell $Merced. He is desperate for any information!",
                    "demons": "Ah yes, my area of research. Between Alterolan of $Tristen and I, we are the foremost experts on the matter!",
                    "Tristen": "Alterolan lives in house Tristen by lake Orn. If you get a chance to visit him, you should. I hear he even managed to capture a live specimen!",
                };
            } else {
                return {
                    "": "I am in your debt friend, for now I can finally leave this place. Merced granted my leave after hearing news of his missing miners, thanks to you. Soon I will leave for home, to continue my research on $demons!",
                    "demons": "Ah yes, my area of research. Between Alterolan of $Tristen and I, we are the foremost experts on the matter!",
                    "Tristen": "Alterolan lives in house Tristen by lake Orn. If you get a chance to visit him, you should. I hear he even managed to capture a live specimen!",
                };
            }
        }
    },
    "onMonsterKilled": (self, monster) => {
    },
};
