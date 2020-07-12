const events_redclaw = {
    "onEnter": self => {
        gameMessage("The fortress Redclaw", COLOR_LIGHT_BLUE);
    },
     "onConvo": (self, n) => {
        if(n.name = "Armel") {
            return {
                "": "Like the tomes say, a $stranger comes to $Redclaw|way castle.",
                "stranger": "Yes, I've read about $this in the library, before it $burned down.",
                "this": "The old tomes say, in times of need, a pale stranger will arrive and seek their $lore. We must do all we can to $aid him in his travels.",
                "lore": "Unfortunatelly, the library $burned down some years ago and Sir Egon did not rebuild it.",
                "burned": "The flames destroyed all the books. Good thing I $read|this most of them before the fire!",
                "aid": "The books mentioned you $stranger and went on to say that the world is in great $danger at the time of your arrival.",
                "danger": "The books did not specify what this danger might be. Perhaps you should seek out $Aiden. He would know more about it.",
                "Aiden": "Aiden is a $sage who resides $upstairs|find.",
                "sage": "A wise fella! He would be able to tell you why you were called on. You just have to $find him in the castle.",
                "find": "The stairs to the second level $burned down with the library, alas. You will have to find another $way upstairs.",
                "way": "Redclaw castle is old... there are hidden passages in the walls... Or so I've heard.",
            };
        }
        if(n.name = "Sir Egon") {
            return {
                "": "I would $venture forth with you, alas I'm too $old.",
                "venture": "Ah the call of adventure! How I miss it. Were I not so $old, I would $join your cause.",
                "old": "Yes, I also used to be an adventurer, back in the day. Now I live here among the $ruins and manage what's left of Redclaw castle.",
                "ruins": "Maybe you talked to my advisor Armel? He can tell you all about the library that burned down some years ago.",
                "join": "If you find someone willing, you should let companions join you on your travels. I'm too $old to go, but ask around, someone might be interested.",
            };
        }
        if(n.name = "Roger") {
            return {
                "": "I'm Roger the $caretaker. Let me know if you need $anything|_trade_.",
                "caretaker": "Oh yes, I've been working in Redclaw $castle longer than anyone else. I remember when Sir Egon was just a $babe!",
                "babe": "He would get into all kinds of trouble. And he used to love hiding in the $passages.",
                "passages": "The castle has many passages. Now, where are they located... Can't remember, but I'll let you know when it comes to me!",
                "castle": "Redclaw is an ancient place. Ask Armel about the library - it was majestic! And like any old place, it has its share of $secrets.",
                "secrets": "Secrets, oh yes! Did you know there is a secret $staircase|passages that descends to Bonefell dungeon? And that Aiden the $sage lives upstairs?",
                "sage": "Aiden is his name and he is a real sage! A knower of many things... to reach him you should find a $way|passages to get upstairs.",
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        if(n.name = "Roger") {
            return [ OBJECT_POTION ];
        }
        return null;
    },
    "onSecret": (self, x, y) => {
        if(x = 3 && y = 16 && getGameState("aiden_secret") = null) {
            return false;
        }
        return true;
    },
};
