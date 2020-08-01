const events_van = {
    "onEnter": self => {
        gameMessage("Deep in the forest is the village Van. At first glance you see no inhabitants.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Ferga") {
            return {
                "": "Look, it's not that I have anything against you but I'd rather not $talk.",
                "talk": "I'm a carnetarian - I only eat $meat. You must admit it's a bit weird talking to food.",
                "meat": "Of course! Being of flora, I find it unconscionable to $consume a plant. I simply refuse to kill anything with a root or $leaf.",
                "leaf": "Yes, yes I grow corn and cabbages... Everyone loves to point that out, I can assure you. Nor is the irony lost on me, that the only farmer in Van doesn't $eat|talk his produce.",
                "consume": "So this is why I've subsisted on a meat-only diet for the past year. I feel healthier, lighter on my feet, and definitely less $guilty about my choices.",
                "guilty": "...Or I did until you showed up. I never realized that consciousness, or the ability to experience the world was not limited to only $plants.",
                "plants": "I guess us Mycoids are living a sheltered life, in a world that is stranger than we dreamt of in our philosophy. Maybe I'll pose this riddle to $Xurcelt when I see him next...",
                "Xurcelt": "Oh you have not met him? He's the wisest being in all of the forest. If you're looking for answers, you should definitely $seek him out. Just be $careful when you approach - he does not like visitors.",
                "seek": () => {
                    setGameState("quest_xurcelt", true);
                    return "How to find him? Well now... you simply, uh... hmm it's difficult to explain... Just follow the roots through the forest.";
                },
                "careful": "$Xurcelt is a deep thinker who does not like intrusion. He barely tolerates us Mycoids and I really don't know how he will react to talking $food|meat.",
            };
        }
        if(n.name = "Xennus") {
            return {
                "": "Uh... eh-hmm... I is Xennus! I love $mushroom! I $mayor!",
                "mushroom": "I is mushroom. You is mushroom. I looove mushroom. Not evil, not poison... Mushroom friend! I is $boss|mayor mushroom.",
                "mayor": () => {
                    if(getGameState("mayor_xennus") = true) {
                        return "Yes, Xennus is mayor. I am boss to all $mushroom. I have secret $knowledge to make good boss! Oops...";
                    } else {
                        return "Yes, Xennus is mayor. I am boss to all $mushroom in Van. I is good boss. Not poison.";
                    }
                },
                "knowledge": "I is not say knowledge. I say 'sludge'. You not hear $correct.",
                "correct": "Xennus $boss|mayor knows when he speak good. Why would I give secret $clue? Xennus too smart, haha!",
                "clue": () => {
                    setGameState("xennus_weird", true);
                    return "Clue? Not clue, I say 'blue'. Secret knowledge harbor only good! Good for Van! Good for all $mushroom.";
                },
            };
        }
        if(n.name = "Zerg") {
            return {
                "": "Hullo, dear. Welcome to the $Mycoid village of Van. Let me know if my $herbs|_heal_ can be of use.",
                "Mycoid": "I've also heard us described as 'Mushroom People', outside the $forest. Some of us - disguised - do get out, regardless of what that old bag of $spores thinks.",
                "spores": "Oh I'm talking about Ferga of course. He's an incessent prattler and usually a bore. He told you about his $diet, did he?",
                "diet": "How he never harms a $plant|Mycoid... 'not one with root or leaf'... Haha, he thinks he's high and mighty because he only eats meat. Ridiculous! Did you know some scholars do not think of us as plants or animals, but rather a third category? Wait until I tell him that! He will blow his cap!",
                "forest": "We live relatively peaceful lives here in the forest. It hides and protects us, although lately we've experienced some of the $troubles from the outside world.",
                "troubles": "Dark shapes have been seen in the village at night. Unnatural dark shapes... Then also there is Xennus, who doesn't seem like $himself.",
                "himself": () => {
                    if(getGameState("xennus_weird") = true) {
                        return "So you also think something is off about him? You should ask our forest scholar $Xurcelt about this. If anyone, he will have the answer.";
                    } else {
                        setGameState("mayor_xennus", true);
                        return "Xennus, our mayor, is usually an affable Mycoid. But for the past few months he's been grumpy and withdrawn... you almost never see him in daylight. If you could see what's eating him, I sure would appreciate it!";
                    }
                },
                "Xurcelt": "All I know is that he is very old and very wise. I hate to say it, but talk to $Ferga|spores. He's the only one who knows how to get to him. Good luck!",
            };
        }
        if(n.name = "Mirgle") {
            return {
                "": "I brew $potions|_trade_ of all kinds here in $Van. Let me know if you need some.",
                "Van": "Van is our hidden village in the $forest. Our $mayor Xennus runs the town.",
                "forest": "The village is not easy to find, right? This is how we keep out of trouble. Also, $Xennus|mayor helps us all get along.",
                "mayor": "Oh yeah you should go meet mayor Xennus. A wiser Mycoid has never lived than he! Although $lately he's been unusually gruff.",
                "lately": "There must be a lot on his mind. Running a village like $Van is stressful work, I guess. Still, he used to be nicer. It's as if he's not himself these days!",
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        if(n.name = "Mirgle") {
            return [ OBJECT_POTION, OBJECT_SUPPLIES ];
        }
        return null;
    },
};
