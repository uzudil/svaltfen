const events_xurcelt = {
    "onEnter": self => {
        gameMessage("Sunlight falls filtered by the leaves all about you. You sense serenity, yet something is not quite right here.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Xurcelt") {
            return {
                "": "I guess my $children failed to pursuade you to leave. Feel free to do so now. Where I'm going you can't possibly $follow.",
                "children": "Yes, the vegetal warriors you no doubt massacred on your way here. Their job was to keep the like of you out so I can $focus|follow.",
                "follow": "You're interested in my work? I'm generally not inclined to $explain myself. If there is one thing I've learned over the centuries is that humans are not to be trusted.",
                "explain": "Well if you insist... My name is Xurcelt. I'm older than anything you've seen before. Human memory suffers from the weakness of your race: it is self - referential. But there is $another realm under your feet and that is where I exist.",
                "another": "Quite literarly under you, in fact. My appearance to you as a tree-person is just an aspect of the energies of my real self, as it is in $Yrgalt.",
                "Yrgalt": "Yrgalt, or as you call it 'the under-world'. Deep under the lands of Svaltfen is Yrgalt, another dimension, given to those $Frehyen who oppose dominion of the sky.",
                "Frehyen": "We are ancient powers from the time when the world of Svaltfen was formed. Maybe $someone told you the story of our $division into sky and under-world powers.",
                "someone": "If you talk to one of the sages in the Ashnar library, they know our $story|division... for the most part.",
                "division": "The $Frehyen of $Yrgalt are at odds with their sky-dwelling brethren, but normally there is no real conflict. However periodically, $one arises to fan the flames of discontent.",
                "one": "Malleus, he's called and he is the reason why I'm here. He's a populist and a fool, risking all of $Yrgalt for personal gain. I $discovered what he's really planning and fled here to Svaltfen when he threatened me.",
                "discovered": "I believe his goal is to attack the $Frehyen of the sky using some kind of $weapon. This weapon is here somewhere in Svaltfen - this is what I'm trying to discover.",
                "weapon": "Long ago, visitors arrived in Svaltfen from a fearsome reality. Though we could barely communicate, it was apparent that all they wanted was to $dominate. Their sky-pods left much arcane weaponry all around Svaltfen.", 
                "dominate": "$Malleus|one plans to $bargain the lands of Svaltfen in order to gain control of their technology. If this were to happen the balance of sky vs $Yrgalt would be lost and Malleus would rule over the ruins of what was once Svaltfen.",
                "bargain": "The mayor of Van may already be such a creature? That is terrible news. $Something must be done about this right away.",
                "Something": () => {
                    # malleus is using the books' power to summon the demons - so Xurcelt essentially gives the same quest as the sages w/o knowing it
                    setGameState("quest_books", true);
                    return "Go and see what $Malleus|one is doing and stop it if you can. From the dungeons under the fortress of Skyforge you can activate a dimensional gate to $Yrgalt by reciting the phrase: 'Emerald Domain'. Hurry, there is no time to lose!";
                }
            };
        }
        return null;
    },
};
