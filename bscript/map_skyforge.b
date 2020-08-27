const events_skyforge = {
    "onEnter": self => {
        gameMessage("You enter a tower with many floors. The tops of its spires are lost in the clouds.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Ylonda") {
            return {
                "": "What is it you seek here stranger, in the ruins of our crumbling $estate? Do you not see the $doom that dwells here? Unless you bring $news of interest, leave me be.",
                "estate": "You are in the once shining castle Skyforge that my $relatives built by hand, stone upon stone. Though once mighty, it has fallen to $ruin|doom.",
                "relatives": "I am the last of the line of the family Skyforge that once ruled $here|estate. The once mighty blaze of our reign will soon be reduced to ashes and $smoke|doom.",
                "doom": "Have you not noticed the tombs of my ancestors in the main halls of the castle? Their downfall was hastened by a monsterous invasion. Though we have managed to repell them, I fear they may yet $return.",
                "return": "Ask Garein and Meggar, my servants, they may know more about these creatures. As for me, I plan to live out the autumn days of the end of a $noble|relatives bloodline here in this chamber. Now go and disturb me no more.",
                "news": () => {
                    if(getGameState("blue_anvil_note") = true) {
                        gameMessage("You show Ylonda the note from house Tristen.", COLOR_GREEN);
                        return "I $recognize that handwriting!";
                    } else {
                        return "Your idle talk bores me. Let me $mourn|doom the fall of the house of $Skyforge|relatives in peace!";
                    }
                },
                "recognize": "That was written by Alterolan of house Tristen! In fact I remember a little $story she told me about it.",
                "story": () => {
                    setGameState("alterolan_sygil", true);
                    return "She said that I was to remind her, in case she forgot, that to open the grate to the backyard, one must utter the words 'Xragane' and wave both hands across one's front. I'm not sure what this means, but I hope you find it useful.";
                }
            };
        }
        if(n.name = "Garein") {
            return {
                "": "Welcome to $Skyforge stranger. Let me know if you require $healing|_heal_.",
                "Skyforge": "Talk to the Lady Ylonda about the castle's history. I've only been here since the recent $troubles began.",
                "troubles": "We had to block the doors of the $cellars, on account of the $creatures that came forth from it! There used to be a door leading to the outside from the north guest-room, but the masons filled it in.",
                "cellars": "Aye the cellars can be accessed from a garden to the north of here. Or, I should say could, because they've been walled off due to the $troubles.",
                "creatures": "Strange moving slimes and small humanoids with clubs crawled forth at night from the $cellars, so we had it $blocked|troubles.",
            };
        }
        if(n.name = "Meggar") {
            return {
                "": "Meggar at yer service, m'lord. I serve the Lady Ylonda and try to keep the $beasts from destroying what's left of the $place.",
                "place": "Once a mighy castle Skyforge is now just a ruin. The tombs in the great hall are all that's left of Lady Ylonda's folk and now with the $monster|beasts attacks we may not last long either.",
                "beasts": "They issued attacks at night from the cellars until Garein locked its entrance. I fear the end of Skyforge is near...",
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        return null;
    },
};
