const events_world1 = {
    "onEnter": self => {
    },
    "onConvo": (self, n) => {
        if(n.name = "Aiden") {
            return {
                "": "Help and old $hermit by $buying|_trade_ some potions, stranger.",
                "hermit": "My name is Aiden, and you're welcome in my humble $home among the trees. I live here, make $potions|_trade_ and await the arrival of a $lost soul.",
                "home": "Up until recently my home was in a castle to the south. However, an $accident|lost forced me to relocate. And honestly, I prefer the solitude of the forest.",
                "lost": "Oh... you have found my servant at Redclaw and was directed here? That can only mean... You are the one I'm waiting for! You are the one we all await. Sit down and listen as I $recount your heritage... and your destiny.",
                "recount": "When the world of Svaltfen was formed, the cosmic powers of those antediluvian days, the $Frehyen, waged war over their creation. Who would be the deity whom Svaltfen's children would call god?",
                "Frehyen": "In the end, the lord of Frehyen, Mittelurgald rose in wraith and glory. He $smote his bickering offspring and cloistered them in two groups.",
                "smote": "'Let those on the left rule as the group humanity loves, and let those on the right be that they fear.' he $decreed.",
                "decreed": "Thus it came to be that the humans of Svaltfen to this day, show obeisance to the $Amlen|gods, the gods of the sky and fear the lords of the Underworld, the $Utlen|gods.", 
                "gods": "This balance of gods - both above and below - kept our world in harmony for eons. But every few thousand years, the symmetry is broken, when one side or the other becomes too $powerful.",
                "powerful": "We call these periods the $Cursed Years. When the balance is broken, the gods plan for war and forget their duties, to be guardians of Svaltfen.",
                "Cursed": "As a $sage, it is my duty to end the Cursed Years and restore the balance of the $Frehyen.",
                "sage": "Usually the $sages of Svaltfen meet (there are four of us) and use our magics to summon a Fregnar, a resurrected hero of old, to fulfill the tasks set forth in our tomes of knowledge.",
                "sages": "You have found me, and say you woke to life in an underground crypt. It sure seems like you are the Fregnar of this Cursed Year. There is only one $problem.",
                "problem": "I have not summoned you. Nor, to my knowledge, did any of the other sages. So the question, is: who is your master $Fregnar _name_?",
                "Fregnar": "I believe the prudent thing to do would be for you travel to Ashnar, the library of sages, and consult the tomes of knowledge. Maybe someone there will know something $more.",
                "more": "I will also do some research of my own and meet you at $Ashnar.",
                "Ashnar": "To get to Ashnar you will have to find a way into the Grunvalt mountains to the north. The library is high among the peaks.",
            };
        }
        return null;
    },
};
