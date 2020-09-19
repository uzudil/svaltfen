const events_ered = {
    "onEnter": self => {
        gameMessage("Ered is a small fishing village.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Carl") {
            return { 
            "": "This here $mining town needs a hero. Will it be you, stranger? Even $Rosa is out of ideas.",
            "mining": "Aye, we would take rare ores from the $deep, but no more. Not since we dug into the $lower levels anyway.",
            "deep": "The mine entrance behind that metal fence, but beware! Do not venture into the shafts... they're $cursed|lower!",
            "lower": "Talk to $Rosa to hear the whole sordid tale. The short of it is, on the lower level the miners tunnelled into the lair of... something evil. No one can say exactly what manner of beast is down there but it and its minions killed every miner we had.",
            "Rosa": "Rosa is the town's scholar. She lives in the large wood house on the north side of town.",
            };
        }
        if(n.name = "Anton") {
            return {
                "": "I used to be a $miner, but now I just $drink...",
                "drink": "What else is there to do when $mine|past is closed? The drink is all I have these days...",
                "miner": "And a good one too! The metal I'd dug up would put food on my table. Alas, that's all in the $past now.",
                "past": "Have ye not heard? The mine is closed, on account of some kind of $beast in its shafts. I saw it and I'm never going down there again!",
                "beast": "It still gives me shivers just to describe it... In the dim light of our torches, we glimpsed a fearsome demon. Red as a lobster and taller than a bear. I can still hear the screaming as it dragged off Agre... And $they say, the lower level has even worse monsters.",
                "they": "Well now, I can't remember who told me about the beast below. I would ask $Rosa, she'll tell you all about it.",
            };
        }
        if(n.name = "Shele") {
            return {      
                "": "What will you $have|_trade_ deary? I'm fast running out with all these $miners out of work.",  
                "miners": "Anton over here is one. Since the mine closed, he's in here every day, drinking the hours away. Now what can I $get|_trade_ you?",
            };
        }
        if(n.name = "Zolan") {
            return {
                "": "Welcome to my armory, esteemed guest! The finest blades and armor away is but a $trade|_trade_ away!",
            };
        }        
        if(n.name = "Meddrin") {
            return {
                "": "Ah yes stranger, be welcome in my shop. Do let me know if you need $potions|_trade_ or $supplies|_trade_.",
            };
        }        
        if(n.name = "Rosa") {
            return {
                "": "Welcome to $Ered stranger. Travelers are always welcome here although we have had better times in the $past. I fear unless $help arrives, Ered will slowly diminish.",
                "Ered": "Ered is a small mining town on the edge of the bay. In the $past we would trade metal ores all over Svaltfen. The weapons and armor produced by our smiths were legendary!",
                "past": "Our products and ore became more popular and we decided to expand our mining operations. We dug new shafts in search of metal ores, until one day we tunnelled into a large underground cave system. What we found there $changed our lives for good.",
                "changed": "By the flickering light of our torches, we saw monsterous creatures lurking in the dark! They attacked and dragged off the miners into the depths. Their dying screams echo in my mind to this day. I feel, I failed our community and don't know if I can ever $regain|help their trust.",
                "help": "What Ered needs is $someone brave enough to venture down into the mines and kill the monsters there. I would $join up for such an adventure because I feel personally responsible for the town's fate.",
                "someone": "You would be willing to undertake this dangerous task? I would gladly $aid|join you in your quest!",
                "join": () => {
                    joinParty(n, 6);
                    return "We're stronger together. Onward, for Ered!";
                },
            };
        }         
        return null;
    },
    "onTrade": (self, n) => {
        if(n.name = "Zolan") {
            return [ OBJECT_ARMOR, OBJECT_WEAPON ];
        }
        if(n.name = "Meddrin") {
            return [ OBJECT_SUPPLIES, OBJECT_POTION ];
        }
        if(n.name = "Shele") {
            return [ OBJECT_FOOD, OBJECT_DRINK ];
        }
        return null;
    },
};
