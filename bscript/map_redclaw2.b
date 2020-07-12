const events_redclaw2 = {
    "onEnter": self => {
        gameMessage("The fortress Redclaw, upper level", COLOR_LIGHT_BLUE);
    },
     "onConvo": (self, n) => {
        if(n.name = "Aspect of Aiden") {
            return {
                "": "Shtay human... yesh. I will $abshtain|abstain from feashting on your flesh jusht thish once. I carry a $meshage for one from $beyond.",
                "abstain": "<Shigh>... Were it not for thish binding, I could haunt in pieshe. Your $undead|beyond corpuleshenshe would make a fine meal. Alash I am bound to deliver a $meshage instead.",
                "beyond": "Takesh one to know one, right? I can $shmell|smell the gravesh whence you $crawled forth from.",
                "smell": "Well ok, not shmell technically, but let us not shplit hairsh. Let us just shay, you were reshently on my $shide|side of the Fenshe, right?",
                "side": "Pushing up $daishies|daisies?",
                "daisies": "Kicked the ole $bucket?",
                "bucket": "Shwimming with the $fishesh|fishes?",
                "fishes": "I'm shaying, you pershon of very shlow intelect, that you were reshently dead. Desheashed. Shtiff ash a plank. I'm jusht shaying, I can tell. I'm a $ghosht|ghost afterall.",
                "ghost": "Yesh, ash in undead. And I carry a meshage, though now I really don't feel like $delivering it.",
                "delivering": "You didn't laugh at my jokesh. It's inshulting, shince I've been working on them for shuch a $long time.",
                "long": "How long? Well let letshee... I burned down the $library about 5 yearsh ago, which ish when $Aiden bound me and left me here. Sho... five yearsh, give or take.",
                "library": "What a fantashtic conflagration that wash! Ah good timesh. Too bad $Aiden got sho mad.",
                "Aiden": "Aiden the shage, yesh. He ish the one holding my leash unfortunatelly. He ish the one who bid me to tell you hish $meshage... Opps. I guesh now I musht tell you.",
                "meshage": "Are you making $fun|abstain of how I shpeak? Very brave for one sho reshently $shummoned|beyond. I will accept your $apology.",
                "apology": "Fine. The meshage is thish: 'Do not lose hope shtranger. All will be revealed. Follow the $shecret|secret way through Bonefell dungeon, pash between two $candolabras, and sheek me out in $Midgreen Foresht.'",
                "candolabras": "I am at a losh to exshplain what that meansh. Would you like to hear the $meshage|apology again?",
                "Midgreen": "A small foresht northwesht of here. After the deshtruction of hish library, $Aiden moved there. Would you like to hear the $meshage|apology again?",
                "secret": "Oh I shupposhe $he|Aiden ish referring to the hidden $shtairs|stairs to Bonefell. Would you like to hear the $meshage|apology again?",
                "stairs": () => {
                    setGameState("aiden_secret", true);
                    return "You can't find it? And you call yourshelf and adventurer?! I guesh I musht shpell it out for you: the shtairsh are on the lower level in the room with Armel. On the wesht wall. Would you like to hear the $meshage|apology again?";
                },
            };
        }
        return null;
    },
};

