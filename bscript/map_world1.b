const events_world1 = {
    "onEnter": self => {
    },
    "onConvo": (self, n) => {
        if(n.name = "Aiden") {
            return {
                "": () => {
                    if(getGameState("mark_of_fregnar") = null) {
                        return "Help and old $hermit by $buying|_trade_ some potions, stranger."; 
                    } else {
                        return "Welcome back $Fregnar _name_. Let me know if you need $potions|_trade_, or if you want to hear the $story|recount of Svaltfen again.";
                    }
                },
                "hermit": "My name is Aiden, and you're welcome in my humble $home among the trees. I live here, make $potions|_trade_ and await the arrival of a $lost soul.",
                "home": "Up until recently my home was in a castle to the south. However, an $accident|lost forced me to relocate. And honestly, I prefer the solitude of the forest.",
                "lost": "Oh... you have found my servant at Redclaw and was directed here? That can only mean... You are the one I'm waiting for! You are the one we all await. Sit down and listen as I $recount your heritage... and your destiny.",
                "recount": "When the world of Svaltfen was formed, the cosmic powers of those antediluvian days, the $Frehyen, waged war over their creation. Who would be the deity whom Svaltfen's children would call god?",
                "Frehyen": "In the end, the lord of Frehyen, Mittelurgald rose in wrath and glory. He $smote his bickering offspring and cloistered them in two groups.",
                "smote": "'Let those on the left rule as the group humanity loves, and let those on the right be that they fear.' he $decreed.",
                "decreed": "Thus it came to be that the humans of Svaltfen to this day, show obeisance to the $Amlen|gods, the gods of the sky and fear the lords of the Underworld, the $Utlen|gods.", 
                "gods": "This balance of gods - both above and below - kept our world in harmony for eons. But every few thousand years, the symmetry is broken, when one side or the other becomes too $powerful.",
                "powerful": "We call these periods the $Cursed Years. When the balance is broken, the gods plan for war and forget their duties, to be guardians of Svaltfen.",
                "Cursed": "As a $sage, it is my duty to end the Cursed Years and restore the balance of the $Frehyen.",
                "sage": "Usually the $sages of Svaltfen meet (there are four of us) and use our magics to summon and mark a Fregnar, a resurrected hero of old, to fulfill the tasks set forth in our tomes of knowledge.",
                "sages": "You have found me, and say you woke to life in an underground crypt. It sure seems like you are the Fregnar of this Cursed Year. There is only one $problem.",
                "problem": "I have not summoned you. Nor, to my knowledge, did any of the other sages. So the question, is: who is your master $Fregnar _name_?",
                "Fregnar": "I believe the prudent thing to do would be for you travel to Ashnar, the library of sages, and consult the tomes of knowledge. Maybe someone there will know something $more.",
                "more": () => {
                    if(getGameState("mark_of_fregnar") = null) {
                        gameMessage("You receive the Mark of the Fregnar.", COLOR_GREEN);
                        setGameState("mark_of_fregnar", true);
                        return "To help you in your quest, I now mark you as Fregnar, sage-aide. This mark will be visible to your allies. I will see you again in $Ashnar.";
                    } else {
                        return "I will also do some research of my own and meet you at $Ashnar.";
                    }
                },
                "Ashnar": "To get to Ashnar you will have to find a way into the Grunvalt mountains to the north. The library is high among the peaks.",
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        if(n.name = "Aiden") {
            return [ OBJECT_POTION ];
        }
        return null;
    },
    "onTravel": (self, x, y) => {
        if(x = 26 && y = 26) {
            if(getGameState("untervalt_password") = null) {
                gameMessage("The iron gates won't budge!", COLOR_MID_GRAY);
                if(array_find_index(player.party, pc => pc.name = "Morten" && pc.hp > 0) > -1) {
                    startConvo({ "name": "Morten" }, {
                        "": "If you want to enter the Grunvalt $Passage, allow me to $help|historian.",
                        "Passage": "Built long ago by the order of Sages, this passage leads to the heart of the Grunvalt mountains. In the distant past, ancient sages used it to reach the $library at Ashnar.",
                        "library": "Nowadays the sages just teleport there using magic. No one knows how long the passage stood closed like this. But lucky for us, I'm a $historian!",
                        "historian": "I studied the histort of Fregnar and the sages. During my studies I came across the $password which unlocks the gates of Grunvalt Passage.",
                        "password": () => {
                            setGameState("untervalt_password", true);
                            return "Let's see now... I believe the phrase was: 'Open for rightous, Fregnar, Frehyen-bane!'. Hmmm, maybe you should try it.";
                        },
                    });
                }
                return false;
            } else {
                gameMessage("You recite the password and the vast gates creak open!", COLOR_GREEN);
            }
        }
        return true;
    },
};
