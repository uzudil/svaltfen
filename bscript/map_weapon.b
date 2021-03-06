const TELEPORTERS = [
    [ 44, 45, 48, 45 ],
    [ 47, 36, 52, 36 ],
    [ 43, 30, 42, 27 ],
    [ 32, 33, 30, 31 ],
    [ 33, 43, 31, 44 ],
    [ 41, 41, 32, 7 ],
];

const ALIENS = [
    [ 3, 22 ],
    [ 4, 23 ],
    [ 6, 23 ],
    [ 8, 23 ],
    [ 4, 21 ],
    [ 6, 21 ],
    [ 8, 21 ],
];

const CTRLS = [
    [ 8, 13 ],
    [ 10, 13 ],
    [ 12, 13 ],
    [ 8, 11 ],
    [ 10, 11 ],
    [ 12, 11 ],
];

def showSpecialTeleporterWeaponMap(showMessage) {
    b := 43;
    if(getGameState("weapon_switches") != null) {
        if(getGameState("weapon_switches") >= 5) {
            if(showMessage) {
                gameMessage("A tremor shakes the earth!", COLOR_YELLOW);
            }
            b := 112;
        } else {
            if(showMessage) {
                gameMessage("Click.", COLOR_MID_GRAY);
            }
        }
    }
    setBlock(41, 41, b, 0);
    setGameBlock(41, 41, b);
}

const events_weapon = {
    "onEnter": self => {
        if(mapMutation.npcs["Xartum"] = null) {
            array_foreach(ALIENS, (i, a) => setMonsterEnabled(a[0], a[1], false));
        }

        # show the special teleporter
        showSpecialTeleporterWeaponMap(false);

        # put the bridge back
        # this should be automatic, except setGameBlock saves w/o rotatation so it looks weird, and I don't feel like fixing that function...
        if(getGameState("ectalius_off") = true) {
            setBlock(11, 27, 76, 1);
            setGameBlock(11, 27, 76);
        }

        gameMessage("You emerge on a rocky plain with mountains on all sides. The air smells faintly of herbs you can't quite recognize.", COLOR_LIGHT_BLUE);
    },
    "onTeleport": self => {
        return TELEPORTERS;
    },
    "onConvo": (self, n) => {
        if(n.name = "Aidan") {
            return {
                "": "I hope you don't mind but I traveled after you to this awful place. It's critical that your mission succeeds and the weapon is disabled. Anytime you need $healing|_heal_ just return to me!"
            };
        }
        if(n.name = "Xartum") {
            return {
                "": "We sense you are other from the one named $Malleus. Are you also seeking the weapon $Ectalius?",
                "Malleus": "Yes, like you, they came to us, threatening at first, then beguiling. Their rage at the sky-beings was useful to us at the time, though we no longer seem to be able to $locate them.",
                "locate": "We sense all active forms, but Malleus is visible to us no more. Perhaps they have $deactivated?",
                "deactivated": "Ah we see... that would explain their abscense. Their quest to control $Ectalius amused us.",
                "Ectalius": "In the right hands, a mighty $weapon. Do you wish to $control|mastery Ectalius?",
                "weapon": "$Malleus did not contain the ken required to operate $Ectalius. Do you wish to acquire this $mastery?",
                "mastery": "Know then that the weapon contains information. And information is the weapon. Eons ago we understood that only such a weapon can enthrall civilizations. The enthralled must willingly submit and only then is our job to control another successful. To this end we $built $Ectalius, the mighty weapon.",
                "built": "Linked together through the deep reaches of space is $Ectalius. The writhing whorls of energy criss-cross the universe and connect the disparate units that make up the whole. Each conquered place contains a unit of the weapon. On each unit is written $truths which though known are not understood by the people there.",
                "truths": "The truths contained in $Ectalius are always tailored to their space and mythos. Here, in what you call Svaltfen, the truth is about $you.",
                "you": "Have you not wondered Fregnar what your role is in the shaping of this land? How is a resurrected hero of old to stop the battle between the Frehyen of sky and earth? The information in this unit of the weapon $Ectalius will set this truth $free.",
                "free": "Our agents are at work now spreading the knowledge in your towns and villages. All will soon be aware of hopelessness of your cause. One cannot stand in the way of such migthy combatants. To trust in one would be $folly.",
                "folly": "Only through our help, by depending and submitting to us - saviours from space, can the lands of Svaltfen be saved. Especially after the $tragic fate of its Fregnar.",
                "tragic": "We're sure you would understand the need for your deactivation, Fregnar. The truths are much more compelling with your untimely $demise...",
                "demise": () => {
                    # no retreat
                    setBlock(11, 27, 0, 0);
                    setGameBlock(11, 27, 0);

                    array_foreach(ALIENS, (i, a) => setMonsterEnabled(a[0], a[1], true));
                    gameMessage("Xartum becomes enraged!", COLOR_YELLOW);
                    removeNpc(n.name);
                    return null;
                }
            };
        }
        return null;
    },
    "onTrade": (self, n) => {
        return null;
    },
    "onSecret": (self, x, y) => {
        return true;
    },
    "onMonsterKilled": (self, monster) => {
        #trace("monster killed=" + monster.monsterTemplate.name + " id=" + monster.id);
        if(monster.monsterTemplate.name = "Xurtang Thrall" && monster.id = "3,22") {
            gameMessage("You find a small key, shaped like a mess of tentacles.", COLOR_YELLOW);
            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Swirl Key"]);
        }
    },
    "onDoor": (self, x, y) => {
        if(x = 6 && y = 19) {
            key := array_find_index(player.inventory, i => i.name = "Swirl Key");
            if(key = -1) {
                gameMessage("The grate is locked.", COLOR_MID_GRAY);
                return true;
            } else {
                gameMessage("You unlock the grate!", COLOR_MID_GRAY);
            }
        } else {
            if(x = 10 && y = 9) {
                if(getBlock(x, y).block = 108) {
                    array_foreach(CTRLS, (i, c) => {
                        setBlock(c[0], c[1], 121, 0);
                        setGameBlock(c[0], c[1], 121);
                    });
                    setBlock(10, 9, 65, 0);
                    setGameBlock(10, 9, 65);

                    # put the bridge back
                    setBlock(11, 27, 76, 1);
                    setGameBlock(11, 27, 76);

                    setGameState("ectalius_off", true);
                    gameMessage("You throw the switch: a massive electric spike destroys the alien hardware and the switch itself.", COLOR_GREEN);
                } else {
                    return true;
                }                
            } else {
                d := 0;
                if(getBlock(x, y).block = 108) {
                    d := 1;
                }
                if(getBlock(x, y).block = 109) {
                    d := -1;
                }
                v := getGameState("weapon_switches");
                if(v = null) {
                    v := 0;
                }
                v := v + d;
                #trace("weapon_switches=" + v);
                setGameState("weapon_switches", v);

                showSpecialTeleporterWeaponMap(true);
            }
        }
        return false;
    },
};
