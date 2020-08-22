const TELEPORTERS = [
    [ 44, 45, 48, 45 ],
    [ 47, 36, 52, 36 ],
    [ 43, 30, 42, 27 ],
    [ 32, 33, 30, 31 ],
    [ 33, 43, 31, 44 ],
    [ 41, 41, 32, 7 ],
];

const events_weapon = {
    "onEnter": self => {
        if(mapMutation.npcs["Xartum"] = null) {
            setMonsterEnabled(18, 15, false);
            setMonsterEnabled(20, 15, false);
            setMonsterEnabled(22, 15, false);
            setMonsterEnabled(20, 13, false);
            setMonsterEnabled(22, 13, false);
        }
        gameMessage("You emerge on a rocky plain with mountains on all sides. The air smells faintly of herbs you can't quite recognize.", COLOR_LIGHT_BLUE);
    },
    "onTeleport": self => {
        return TELEPORTERS;
    },
    "onConvo": (self, n) => {
        if(n.name = "Xartum") {
            return {
                "": "Welcome humans. It is known to me why you are here. But, haha, $Xartum is too $smart to give away $secret code that would disable $Ectalom.",
                "Xartum": "Yes, I am called Xartum. You must have many questions, like: $what? $why|what? or What will happen to my flesh after Xartum $drains my consciousness? Don't fear all will be answered!",
                "drain": "Oh yes, that is mainly $why|what my people are here for in Svaltfen. Due to an increase in... uh, demand, we seek new venues of expansion. The great hunger of our people cannot be denied.",
                "what": "",
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
    "onDoor": (self, x, y) => {
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
        trace("weapon_switches=" + v);
        setGameState("weapon_switches", v);
        if(v = 5) {
            gameMessage("A tremor shakes the earth!", COLOR_YELLOW);
            b := 112;
        } else {
            gameMessage("Click.", COLOR_MID_GRAY);
            b := 43;
        }
        setBlock(41, 41, b, 0);
        setGameBlock(41, 41, b);
        return false;
    },
};
