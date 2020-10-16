const events_mine2 = {
    "onEnter": self => {
        if(mapMutation.npcs["Yggxurantes"] = null) {
            setMonsterEnabled(16, 12, false);
        }
        gameMessage("This mine level has low ceilings. An unidentifiable odor lingers in the stale air.", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Yggxurantes") {
            if(getGameState("ectalius_off") = true) {
                return {
                    "": "Normally I would rather just dine on your kind human, however I'm bound to make an exception for you. You have done a great $service for me and let it not be said that $Yggxurantes lacks gratitude.",
                    "Yggxurantes": "My name is Yggxurantes and I come from a long line of red drakes from far across the sea. As you know, dragons live extremely long lives and are superior to $almost all other creatures in Svaltfen.",
                    "almost": "Yes, almost all... It used to be the case that we ruled supreme over all the beasts of Svaltfen, but that is no longer true. You see, a new race has come, we don't know from where, with a fierce hatred and a desire for conquest. I speak of the alien race $Xurtang|service, of course.",
                    "service": "I've learned that you disabled the weapon Ectalius and foiled the plan of the invaders, and for this I'm eternally grateful. As a token of my appreciation, I will give you a portion of my $treasure that I hoarded over the centuries.",
                    "treasure": () => {
                        if(getGameState("dragon_treasure") = null) {
                            setGameState("dragon_treasure", true);
                            player.coins := player.coins + 1000;
                            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Diamond ring"]);
                            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Gold crown"]);
                            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Ancient coins"]);
                            gameMessage("You gain some of the dragon's treasure!", COLOR_GREEN);
                        }
                        return "Leave now human. I appriate you so I don't want to accidentally involve you in my dinner plans...";
                    }
                };
            } else {
                return {
                    "": "Who dares to $disturb my rest? Or have you come to $plead for your life in front of the mighty red $wyrm of Svaltfen?",
                    "plead": "Yes, yes you may grovel in front of me. Perhaps if you speak the $right words I will prevent your $demise|disturb for a few more minutes.",
                    "right": "You are indeed a talented stroker of egos, human! Few lived this long in my presence. Do you wish to hear $who|wyrm I am? Or shall I just proceed with my previous $dinner|disturb plans?",
                    "wyrm": "Very well then, you may hear my history before your $doom|disturb. My name is Yggxurantes and I come from a long line of red drakes from far across the sea. As you know, dragons live extremely long lives and are superior to $almost all other creatures in Svaltfen.",
                    "almost": "Yes, almost all... It used to be the case that we ruled supreme over all the beasts of Svaltfen, but that is no longer true. You see, a new race has come, we don't know from where, with a fierce hatred and a desire for conquest. If you could rid Svaltfen of their kind, well... we could maybe strike a $bargain of sorts.",
                    "bargain": "Know this, then: the race of beings that pose a danger to my kind is called Xurtang. If you ever come accross them in battle, and should you be $victorious, come back to me and let me know.",
                    "victorious": "If you could eliminate the Xurtang threat for me, why, my gratitude would know no limits! Now leave while you still can, human!",
                    "disturb": () => {
                        # convert npc to monster
                        removeNpc(n.name);
                        setMonsterEnabled(16, 12, true);
                        gameMessage("Yggxurantes becomes enraged!", COLOR_YELLOW);
                        return null;
                    },
                };
            }
        }
        return null;
    },
    "onDoor": (self, x, y) => {
        if(x = 46 && y = 24) {
            gameMessage("This grate is jammed and won't open.", COLOR_MID_GRAY);
            return true;
        }
        return false;
    },
};
