const STATE_HUNGER = "hunger";
const STATE_THIRST = "thirst";

# the bad
const STATE_POISON = "poisoned";
const STATE_PARALYZE = "paralyzed";
const STATE_CURSE = "cursed";
const STATE_SCARED = "scared";

# the good
const STATE_SHIELD = "shielded";
const STATE_BLESS = "blessed";
const STATE_INVISIBLE = "invisible";
const STATE_ALERT = "alert";

const STATES = [
    { "name": STATE_HUNGER, "default": 100, "age": (this, pcIndex) => {
        pc := player.party[pcIndex];
        value := agePcState(pc, this);
        if(value = 0) {
            gameMessage(pc.name + " is hungry!", COLOR_RED);
            takeDamage(pc, 1);
            return true;
        } else {
            if(value < 5) {
                gameMessage(pc.name + " needs food!", COLOR_YELLOW);
                return true;
            }
        }
        return false;
    } }, 
    { "name": STATE_THIRST, "default": 100, "age": (this, pcIndex) => {
        pc := player.party[pcIndex];
        value := agePcState(pc, this);
        if(value = 0) {
            gameMessage(pc.name + " is thirsty!", COLOR_RED);
            takeDamage(pc, 1);
            return true;
        } else {
            if(value < 5) {
                gameMessage(pc.name + " needs water!", COLOR_YELLOW);
                return true;
            }            
        }
        return false;
    } }, 
    { "name": STATE_POISON, "color": COLOR_YELLOW, "default": 0, "step": (this, pcIndex) => {
        pc := player.party[pcIndex];
        value := agePcState(pc, this);
        if(value > 0) {
            dam := roll(2, 4);
            gameMessage(pc.name + " takes " + dam + " points of poison damage!", COLOR_RED);
            takeDamage(pc, dam);
            return true;
        }
        return false;
    } }, 
    { "name": STATE_PARALYZE, "color": COLOR_YELLOW, "default": 0, 
        "step": (this, pcIndex) => agePcState(player.party[pcIndex], this), 
        "getArmorMod": (this, pc) => -5 
    }, 
    { "name": STATE_CURSE, "color": COLOR_YELLOW, "default": 0, 
        "getArmorMod": (this, pc) => -3, 
        "getAttackMod": (this, pc) => -4, 
        "getToHitMod": (this, pc) => -3 
    }, 
    { "name": STATE_SCARED, "color": COLOR_YELLOW, "default": 0, 
        "step": (this, pcIndex) => agePcState(player.party[pcIndex], this) 
    }, 
    { "name": STATE_SHIELD, "color": COLOR_GREEN, "default": 0, 
        "step": (this, pcIndex) => agePcState(player.party[pcIndex], this), 
        "getArmorMod": (this, pc) => 7 
    }, 
    { "name": STATE_BLESS, "color": COLOR_GREEN, "default": 0, 
        "step": (this, pcIndex) => agePcState(player.party[pcIndex], this), 
        "getArmorMod": (this, pc) => 4, 
        "getAttackMod": (this, pc) => 4, 
        "getToHitMod": (this, pc) => 4 
    }, 
    { "name": STATE_INVISIBLE, "color": COLOR_GREEN, "default": 0, 
        "step": (this, pcIndex) => agePcState(player.party[pcIndex], this), 
        "getArmorMod": (this, pc) => 5, 
        "getAttackMod": (this, pc) => 2, 
        "getToHitMod": (this, pc) => 2 
    }, 
    { "name": STATE_ALERT, "color": COLOR_GREEN, "default": 0, 
        "step": (this, pcIndex) => agePcState(player.party[pcIndex], this), 
        "getToHitMod": (this, pc) => 2 
    }, 
];
STATE_NAME_INDEX := {};

def initStates() {
    STATE_NAME_INDEX := array_reduce(STATES, {}, (d, s) => { d[s.name] := len(keys(d)); return d; });
}

def describeStates(pc) {
    if(pc.hp <= 0) {
        return "Dead";
    } else {
        return array_reduce(STATES, "", (msg, st) => {
            if(st.name != STATE_HUNGER && st.name != STATE_THIRST) {
                if(pc.state[STATE_NAME_INDEX[st.name]] > 0) {
                    if(len(msg) > 0) {
                        msg := msg + ",";
                    }
                    msg := msg + st.name;
                }
            }
            return msg;
        });
    }
}

def ageState(fxName) {
    changed := [ false ];
    array_foreach(player.party, (i, pc) => {
        if(pc.hp > 0) {
            if(pc["state"] = null) {
                pc["state"] := [];
            }
            trace(fxName + ":" + pc.name + " state=" + pc.state);
            array_foreach(STATES, (t, state) => {
                if(len(pc.state) <= t) {
                    pc.state[t] := state.default;
                } else {
                    if(state[fxName] != null) {                    
                        if(STATES[t][fxName](i)) {
                            changed[0] := true;
                        }
                    }
                }
            });
        }
    });
    if(changed[0]) {
        equipmentFailSound(1);
        setMapEffect(player.x, player.y, [player.x, player.y], EFFECT_DAMAGE);
        drawUI();
        drawView(player.x, player.y);
        updateVideo();
    }

    # age monster state
    if(len(map.monster) > 0) {
        if(map.monster[0]["hp"] != null) {
            array_foreach(array_filter(map.monster, m => m.hp > 0), (i, m) => {
                trace(m.monsterTemplate.name + ":" + m.state);
                array_foreach(keys(m.state), (t, state) => {
                    m.state[state] := m.state[state] - 1;
                });
                k := array_filter(keys(m.state), s => m.state[s] <= 0);
                array_foreach(k, (i, kk) => {
                    del m.state[kk];
                    gameMessage(m.name + " is no longer " + kk + ".", COLOR_MID_GRAY);
                });
            });    
        }
    }
}

def agePcState(pc, state) {
    stateIndex := STATE_NAME_INDEX[state.name];
    setState(pc, state.name, pc.state[stateIndex] - 1);
    return pc.state[stateIndex];
}
