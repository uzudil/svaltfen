const events_tristen = {
    "onEnter": self => {
        gameMessage("Tristen is a large ivy-covered brick house by lake Orn.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Alterolan") {
            return {
                "": "It's not everyday that a humble $scholar is visited by such a mighty $guest. But if all you need is $potions|_trade_ or $healing|_heal_, just ask.",
                "scholar": "Ah yes, my studies are not topics of polite conversation. You see, I'm a scholar of $demons.",
                "guest": "The mark of the Fregnar is as bright as day on you. I can only assume that we have entered a time of troubles and you were sent by the Sages. May my $knowledge|scholar help you on your journey, Fregnar.",
                "demons": "Not just mere monsters for heros to slaughter, the demons of the $Underworld have long fascinated me with their cruel intelligence. Did you know for example that armor made of leather is more useful in defending against them than metal?",
                "Underworld": "Yes, the home of demon-kind is the other realm beneath our feet. If you want to venture there, it is only accessible from a $few places in all of Svaltfen.",
                "few": "The cellars beneath $Skyforge castle is one. Another is in the $mountains to our East. And yet another is from my $backyard.",
                "Skyforge": "The once mighty castle Skyforge is on an island to the East. Rumor has it its cellars harbor a gate to the $Underworld.",
                "mountains": "The Arboril Mountains to the East also have a gate to the $Underworld. But I don't know how to get into the moutains. At this time of year the passes cannot be crossed.",
                "backyard": "Ah yes, using my arcane powers I have created a gate to the $Underworld right here in my backyard. Unfortunatly however, I have sealed the grate leading there because of a summoning gone awry, and I have forgotten the spell that unlocks it. Could you help me $remember it?",
                "remember": () => {
                    if(getGameState("alterolan_sygil") = null) {
                        return "Maybe try looking around my house for clues? Try asking Ellen about it.";
                    } else {
                        return "Thank you for reminding me about the sygil! I will write it down so I don't forget it again.";
                    }
                }
            };
        }
        if(n.name = "Ellen") {
            return {
                "": "Hello there, my name is Ellen. I help out around the house so Alterolan can $focus on her studies.",
                "focus": "She is a great scholar but very forgetful. If it wasn't for me, she'd $forget to eat regular meals even!",
                "forget": "The other day, for example, she practiced a new spell of summoning. After much smoke and mumbling she succeeded in summoning an Underworld fiend, only to $lock it in the back room.",
                "lock": "It's still there, you can go and check. And oooh it's mighty displeased. Anyway, I'm pretty sure Alterolan $forgot how to unlock the gate.",
                "forgot": "The grate is being held close by a magical sygil. The clue to undoing it might be around somewhere here in house Tristen. I would check for lose notes in books in the libraries. And if that turns up only a partial clue, $one other may know more.",
                "one": "Aye, you see Alterolan is great friends with Lady Ylonda from castle Skyforge. They visit each other every odd week or so and discuss everything. If you can't find the clue to unlock that gate here, Lady Ylonda might know.",
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        if(n.name = "Alterolan") {
            return [ OBJECT_POTION ];
        }    
        return null;
    },
    "onDoor": (self, x, y) => {
        if(x = 15 && y = 17 && getGameState("alterolan_sygil_done") = null) {
            if(getGameState("alterolan_sygil") = null) {
                gameMessage("The grate is locked.", COLOR_MID_GRAY);                
            } else {
                setGameState("alterolan_sygil_done", true);
                gameMessage("You say the word 'Xragane' and wave your hands. With a shower of sparks the grate unlocks.", COLOR_GREEN);
                return false;
            }
            return true;
        }
        return false;
    },
    "onLoot": (self, x, y) => {
        if(x = 7 && y = 16) {
            gameMessage("A small note falls out of a book. It reads: 'Blue Anvil'.", COLOR_YELLOW);
            setGameState("blue_anvil_note", true);
            return true;
        }
        return false;
    },
};
