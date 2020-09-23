
const events_ashnar3 = {
    "onEnter": self => {
        gameMessage("The upper level of the Library at Ashnar", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Varten") {
            return {
                "": "How can an old man aid the $Fregnar? Have you come to learn about $magic|_magic_?",
                "Fregnar": "I have $worked alongside the Fregnar long enough to recognize the signs. You carry it and with it the burden of the Cursed Year and the hope of all Svaltfen. If I can aid you with my $magic|_magic_, let me know!",
                "worked": "You see I am the last of my kind in Svaltfen. A long time ago, before the battles of the Frehyen threatened to end life on Svaltfen, us wizards $prospered.",
                "prospered": "Soon though some of the Frehyen became jealous of our powers. Their powers come from their divine nature and they could not stand to think that mere mortals could research and cast magic $spells.",
                "spells": "Although they managed to hunt down and kill most of our kind, I survivied and kept some the $knowledge alive. $Magic|_magic_ is now only available as a last resort to a select few, and that includes you Fregnar.",
                "knowledge": "As you journey on your quest to save Svaltfen, the more experience you gain, the more the arcane wisdom of spells open up to you. Return to me periodically to see if new $magic|_magic_ is available to you.",
            };
        }
        if(n.name = "Ragr") {
            return {
                "": "Welcome valued customer. Please have a look at my $wares|_trade_!",
            };
        }
        if(n.name = "Fren") {
            return {
                "": "In my shop, you have access to the most fearsome $weaponry|_trade_ in Svaltfen. Have a look!",
            };
        }
        if(n.name = "Joyre") {
            return {
                "": "My simple temple is dedicated to $healing|_heal_. All are welcome and no one is turned away.",
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        if(n.name = "Fren") {
            return [ OBJECT_ARMOR, OBJECT_WEAPON ];
        }
        if(n.name = "Ragr") {
            return [ OBJECT_POTION, OBJECT_SUPPLIES ];
        }
        return null;
    },
};
