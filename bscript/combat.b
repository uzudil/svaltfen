combat := {
    "monsters": [],
    "round": [],
    "roundIndex": 0,
    "roundCount": 1,
    "playerControl": false,
};

const OUT_OF_COMBAT_DISTANCE = 16;
const MONSTER_NOTICE_DISTANCE = 10;
#const FIND_PATH_RADIUS = LIGHT_RADIUS * 2 - 1;
const FIND_PATH_RADIUS = 16;

# this is called infrequently from events
def endCombat() {
    gameMode := MOVE;
}

def startCombat() {
    if(gameMode = MOVE && mode != "death") {
        player.party[player.partyIndex].pos[0] := player.x;
        player.party[player.partyIndex].pos[1] := player.y;
 
        monsters := getLiveMonsters(map.monster);
        if(len(array_filter(monsters, m => m.state[STATE_POSSESSED] = null)) > 0) {
            # position party
            array_foreach(player.party, (i, p) => {
                if(i = 0) {
                    p["pos"] := [player.x, player.y];
                } else {
                    p["pos"] := findSpaceAround(player.x, player.y);
                }
            });
            # trace("COMBAT START");
            combatStartSound();
            gameMode := COMBAT;        
            combat.roundCount := 0;
            combat.monsters := monsters;
            initCombatRound();
        }
    }
}

def newCombatRoundMonster(m) {
    round := {
        "type": "monster",
        "creature": m,
        "ap": 10,
        "initiative": m.monsterTemplate.speed,
        "target": null,
        "path": m.path,
        "pathIndex": 0,
        "name": m.monsterTemplate.name,
        "id": m.id,
        "wallBlocks": m.monsterTemplate.wallBlocks,
        "isActive": self => self.creature.visible && self.creature.hp > 0,
        "isInState": (self, state) => self.creature.state[state] != null,
        "initMove": self => {
        },
        "move": self => {
            combat.playerControl := false;
            renderGame();
            updateVideo();
            while(self.isActive() && self.ap > 0) {
                self.ap := self.ap - monsterCombatMove();
                sleep(250);
                renderGame();
                updateVideo();
            }
            combatTurnEnd();
        }
    };
    # remove the original path after first use
    m.path := []; 
    return round;
}

def newCombatRoundPc(pc) {
    return {
        "type": "pc",
        "creature": pc,
        "ap": 10,
        "initiative": pc.speed,
        "name": pc.name,
        "id": "pc" + pc.index,
        "wallBlocks": true,
        "target": null,
        "path": null,
        "pathIndex": 0,
        "isActive": self => self.creature.hp > 0,
        "isInState": (self, state) => isPcInState(self.creature, state),
        "initMove": self => {
            player.partyIndex := self.creature.index;
            player.x := player.party[player.partyIndex].pos[0];
            player.y := player.party[player.partyIndex].pos[1];
        },
        "move": self => {
            combat.playerControl := true;
            gameMessage("It is your turn: " + self.name, COLOR_MID_GRAY);
            renderGame();
            updateVideo();
        }
    };
}

def sortCombatRoundsByInitiative() {
    # order by initiative (speed, really)
    sort(combat.round, (a,b) => {
        if(a.initiative < b.initiative) {
            return 1;
        } else {
            return -1;
        }
    });
}

def initCombatRound() {
    if(combat.roundCount > 0) {
        # find any extra monsters
        new_monsters := getLiveMonsters(array_filter(map.monster, m => {
            return array_find_index(combat.monsters, cm => cm.id = m.id) = -1;
        }));
        # add them
        array_foreach(new_monsters, (i, nm) => {
            combat.monsters[len(combat.monsters)] := nm;
        });
        # remove monsters who are now too far
        array_remove(combat.monsters, m => closestDistanceToParty(m.pos[0], m.pos[1]) >= OUT_OF_COMBAT_DISTANCE);
    }
    combat.round := [];
    combat.roundIndex := 0;
    combat.roundCount := combat.roundCount + 1;
    array_foreach(combat.monsters, (i, p) => {
        combat.round[len(combat.round)] := newCombatRoundMonster(p);
    });
    array_foreach(player.party, (i, p) => {
        combat.round[len(combat.round)] := newCombatRoundPc(p);
    });
    sortCombatRoundsByInitiative();    

    # age states
    if(len(combat.round) > combat.roundIndex) {
        calendarStep(true);    
    }

    gameMessage("Combat!", COLOR_RED);
    runCombatTurn();
}

def isMonsterLive(m) {
    return m.visible && m.hp > 0 && m.state[STATE_PARALYZE] = null;
}

def getLiveMonsters(monsters) {
    return array_filter(monsters, m => { 
        if(isMonsterLive(m)) {
            if(m.state[STATE_POSSESSED] != null) {
                target := array_find(map.monster, t => abs(m.pos[0] - t.pos[0]) <= MONSTER_NOTICE_DISTANCE && abs(m.pos[1] - t.pos[1]) <= MONSTER_NOTICE_DISTANCE && m.id != t.id && t.state[STATE_POSSESSED] = null);
            } else {
                # try to target the possessed monster first,
                target := array_find(map.monster, t => abs(m.pos[0] - t.pos[0]) <= MONSTER_NOTICE_DISTANCE && abs(m.pos[1] - t.pos[1]) <= MONSTER_NOTICE_DISTANCE && m.id != t.id && t.state[STATE_POSSESSED] != null);
                if(target != null) {
                    path := findPath(m, target);
                    if(len(path) > 0) {
                        m["path"] := path;
                        return true;
                    }
                }
                # otherwise, target a pc
                target := array_find(player.party, pc => abs(m.pos[0] - pc.pos[0]) <= MONSTER_NOTICE_DISTANCE && abs(m.pos[1] - pc.pos[1]) <= MONSTER_NOTICE_DISTANCE);
            }
            if(target != null) {
                m["path"] := findPath(m, target);
                return len(m.path) > 0;
            }
        }
        return false;
    });
}

def checkCombatDone() {
    pc := array_filter(player.party, p => p.hp > 0);
    if(len(pc) = 0) {
        startDeathMode();
        return true;
    }
    live_monsters := array_filter(combat.monsters, m => isMonsterLive(m) && m.state[STATE_POSSESSED] = null);
    if(len(live_monsters) = 0) {
        gameMessage("Victory!", COLOR_GREEN);
        # remove controlled monsters?
        # array_remove(map.monster, m => m.state[STATE_POSSESSED] != null);
        combatEndSound();
        gameMode := MOVE;
        player.partyIndex := array_find_index(player.party, p => p.hp > 0);
        return true;
    }
    return false;
}

def runCombatTurn() {
    if(checkCombatDone()) {
        return 1;
    }

    combatRound := combat.round[combat.roundIndex];
    if(combatRound.isActive() = false || combatRound.isInState(STATE_PARALYZE)) {
        combatTurnEnd();
    } else {
        combatRound.initMove();
        if(combatRound.isInState(STATE_SCARED)) {
            combatTurnScared();
        } else {
            combatRound.move();
        }
    }
}

def combatTurnScared() {
    combatRound := combat.round[combat.roundIndex];
    gameMessage(combatRound.name + " runs away scared!", COLOR_YELLOW);
    combat.playerControl := false;
    while(combatRound.creature.hp > 0 && combatRound.ap > 0) {
        scaredMove();
        combatRound.ap := combatRound.ap - 1;    
        sleep(250);
        renderGame();
        updateVideo();
    }
    combatTurnEnd();
}

def closestDistanceToMonsters(mx, my) {
    return array_reduce(map.monster, 100, (v, m) => min(v, distance(m.pos[0], m.pos[1], mx, my)));
}

def closestDistanceToParty(mx, my) {
    return array_reduce(player.party, 100, (m, pc) => min(m, distance(pc.pos[0], pc.pos[1], mx, my)));
}

def scaredMove() {    
    combatRound := combat.round[combat.roundIndex];
    distFx := closestDistanceToMonsters;
    if(combatRound.type = "monster") {
        distFx := closestDistanceToParty;
    }
    d := distFx(combatRound.creature.pos[0], combatRound.creature.pos[1]);
    if(d < OUT_OF_COMBAT_DISTANCE) {

        nx := combatRound.creature.pos[0];
        ny := combatRound.creature.pos[1];

        dx := -1;
        while(dx <= 1) {
            dy := -1;
            while(dy <= 1) {
                if(dx != 0 || dy != 0) {
                    if(canMoveTo(combatRound.creature.id, combatRound.creature.pos[0] + dx, combatRound.creature.pos[1] + dy, null, combatRound.wallBlocks)) {
                        dd := distFx(combatRound.creature.pos[0] + dx, combatRound.creature.pos[1] + dy);
                        #if(monster != null) {
                        #    trace("dir=" + dx + "," + dy + " dd=" + dd);
                        #}
                        if(dd > d) {
                            nx := combatRound.creature.pos[0] + dx;
                            ny := combatRound.creature.pos[1] + dy;
                            d := dd;                            
                        }
                    }
                }
                dy := dy + 1;
            }
            dx := dx + 1;
        }

        if(nx != combatRound.creature.pos[0] || ny != combatRound.creature.pos[1]) {
            if(combatRound.type = "monster") {
                getBlock(combatRound.creature.pos[0], combatRound.creature.pos[1])["blocker"] := null;
            }
            combatRound.creature.pos[0] := nx;
            combatRound.creature.pos[1] := ny;
            if(combatRound.type = "monster") {
                getBlock(combatRound.creature.pos[0], combatRound.creature.pos[1])["blocker"] := combatRound.id;
            }
            stepSound();
        }
    }
    return 1;
}

def monsterCombatMove() {
    combatRound := combat.round[combat.roundIndex];

    # target still valid?
    if(combatRound.target != null) {
        # target died
        if(combatRound.target.hp <= 0) {
            combatRound.target := null;
            combatRound.pathIndex := len(combatRound.path);
        }

        # if target moved: cancel planned path
        if(combatRound.target != null && len(combatRound.path) > 0) {
            lastNode := combatRound.path[len(combatRound.path) - 1];
            if(lastNode.x != combatRound.target.pos[0] || lastNode.y != combatRound.target.pos[1]) {
                combatRound.pathIndex := len(combatRound.path);
            }
        }
    }

    apUsed := 1;
    targetMonster := true;
    if(combatRound.isInState(STATE_POSSESSED)) {
        near_target := array_find(combat.monsters, m => {
            if(m.hp <= 0 || m.id = combatRound.id || m.state[STATE_POSSESSED] != null) {
                return false;
            }
            near := isMonsterNearTarget(m);
            if(combatRound.creature.target != null) {
                return m.id = combatRound.creature.target.id && near;
            } else {
                return near;
            }
        });
    } else {
        near_target := array_find(combat.monsters, m => {
            if(m.hp <= 0 || m.id = combatRound.id || m.state[STATE_POSSESSED] = null) {
                return false;
            }
            near := isMonsterNearTarget(m);
            if(combatRound.creature.target != null) {
                return m.id = combatRound.creature.target.id && near;
            } else {
                return near;
            }
        });
        if(near_target = null) {
            targetMonster := false;
            near_target := array_find(player.party, pc => {
                if(pc.hp <= 0) {
                    return false;
                }
                near := isMonsterNearTarget(pc);
                if(combatRound.creature.target != null) {
                    return pc.name = combatRound.creature.target.name && near;
                } else {
                    return near;
                }
            });
        }
    }
    if(near_target != null) {
        attackMonster(near_target, targetMonster);
        apUsed := combatRound.creature.monsterTemplate.attackAp;
    } else {
        if(combatRound.pathIndex < len(combatRound.path)) {
            # move along path
            if(moveMonster() = false) {
                # if blocked (by another monster), end path
                combatRound.pathIndex := len(combatRound.path);
            }
        }

        if(combatRound.pathIndex >= len(combatRound.path)) {
            # try to find a new target
            combatRound.pathIndex := 0;
            combatRound.path := [];
            try := 0;
            while(try < 3 && len(combatRound.path) = 0) {
                if(combatRound.isInState(STATE_POSSESSED)) {
                    combatRound.target := choose(array_filter(combat.monsters, m => m.hp > 0 && m.id != combatRound.id && m.state[STATE_POSSESSED] = null));
                } else {
                    combatRound.target := choose(array_filter(combat.monsters, m => m.hp > 0 && m.id != combatRound.id && m.state[STATE_POSSESSED] != null));
                    if(combatRound.target = null) {
                        combatRound.target := choose(array_filter(player.party, p => p.hp > 0));
                    }
                }
                if(combatRound.target != null) {
                    #trace("new target: finding path target=" + combatRound.target.index + " from=" + monster.pos + " to=" + combatRound.target.pos);
                    combatRound.path := findPath(combatRound.creature, combatRound.target);
                    combatRound.pathIndex := 0;
                }
                try := try + 1;
            }

            # if we can't find a path, skip rest of turn
            if(len(combatRound.path) = 0) {
                apUsed := combatRound.ap;
            }
        }
    }
    return apUsed;
}

def isMonsterNearTarget(otherCreature) {
    combatRound := combat.round[combat.roundIndex];
    d := [
        combatRound.creature.pos[0] - otherCreature.pos[0],
        combatRound.creature.pos[1] - otherCreature.pos[1]
    ];
    near := abs(d[0]) <= combatRound.creature.monsterTemplate.range && abs(d[1]) <= combatRound.creature.monsterTemplate.range;
    if(near && combatRound.creature.monsterTemplate.range > 1) {
        near := checkProjectile(combatRound.creature.pos[0], combatRound.creature.pos[1], otherCreature.pos[0], otherCreature.pos[1]);
    }
    return near;
}

def combatTurnStep(d) {
    if(checkCombatDone() = false) {
        # spend an AP point
        combat.round[combat.roundIndex].ap := combat.round[combat.roundIndex].ap - d;
        if(combat.round[combat.roundIndex].ap <= 0) {
            combatTurnEnd();
        }
    }
}

def combatTurnEnd() {
    # any participants left?
    pc := array_filter(player.party, p => p.hp > 0);
    live_monsters := array_filter(combat.monsters, m => isMonsterLive(m));
    if(len(pc) = 0 || len(live_monsters) = 0) {
        initCombatRound();
    } else {
        # next creature's turn
        combat.roundIndex := combat.roundIndex + 1;
        if(combat.roundIndex >= len(combat.round)) {
            # next round
            initCombatRound();
        } else {
            runCombatTurn();
        }
    }
}

def moveMonster() {
    combatRound := combat.round[combat.roundIndex];

    moved := false;
    pathNode := combatRound.path[combatRound.pathIndex];
    #trace("At " + combatRound.creature.pos[0] + "," + combatRound.creature.pos[1] + " trying: " + pathNode.x + "," + pathNode.y);
    if(canMoveTo(combatRound.creature.id, pathNode.x, pathNode.y, null, combatRound.wallBlocks)) {
        getBlock(combatRound.creature.pos[0], combatRound.creature.pos[1])["blocker"] := null;
        combatRound.creature.pos[0] := pathNode.x;
        combatRound.creature.pos[1] := pathNode.y;
        getBlock(combatRound.creature.pos[0], combatRound.creature.pos[1])["blocker"] := combatRound.creature.id;
        combatRound.pathIndex := combatRound.pathIndex + 1;
        moved := true;
        #trace("...yes");
    } else {
        #trace("...no");
    }

    if(moved) {
        stepSound();
    } else {
        gameMessage(combatRound.name + " waits", COLOR_MID_GRAY);        
    }
    return moved;
}

def attackMonster(targetPc, targetMonster) {
    combatRound := combat.round[combat.roundIndex];

    if(combatRound.creature.monsterTemplate.range > 1) {
        if(combatRound.creature.monsterTemplate["rangeBlocks"] = null) {
            projectile := [ img["arrow"], img["arrow2"] ];
        } else {
            projectile := array_map(combatRound.creature.monsterTemplate.rangeBlocks, p => img[p]);
        }
        success := animateProjectile(
            combatRound.creature.pos[0], combatRound.creature.pos[1],
            targetPc.pos[0], targetPc.pos[1],
            projectile,
            true
        );
        if(success = false) {
            return 1;
        }
    }

    # roll to-hit
    toHit := roll(0, 20) + combatRound.creature.monsterTemplate.armor;

    if(targetMonster) {
        # possessed creature attacks another monster
        monster := targetPc;
        gameMessage(combatRound.name + " attacks " + monster.monsterTemplate.name + "!", COLOR_MID_GRAY);
        
        if(toHit <= monster.monsterTemplate.armor) {
            gameMessage(combatRound.name + " misses.", COLOR_MID_GRAY);
            combatMissSound();
            return 1;
        }

        # roll damage
        dam := roll(combatRound.creature.monsterTemplate.attack[0], combatRound.creature.monsterTemplate.attack[1]);

        # who gets the experience points?
        pc := null;
        if(combatRound.isInState(STATE_POSSESSED)) {
            pc := player.party[0];
        }

        monsterTakeDamage(pc, monster, dam);
    } else {
        # regular monster to pc attack        
        gameMessage(combatRound.name + " attacks " + targetPc.name + "!", COLOR_MID_GRAY);

        if(toHit <= targetPc.armor) {
            gameMessage(combatRound.name + " misses.", COLOR_MID_GRAY);
            combatMissSound();
            return 1;
        }

        # roll damage
        dam := roll(combatRound.creature.monsterTemplate.attack[0], combatRound.creature.monsterTemplate.attack[1]);
        if(dam > 0) {
            takeDamage(targetPc, dam);
            combatAttackSound();
            setMapEffect(combatRound.creature.pos[0], combatRound.creature.pos[1], targetPc.pos, EFFECT_DAMAGE);
            if(combatRound.creature.monsterTemplate["onHit"] != null) {
                combatRound.creature.monsterTemplate.onHit(targetPc);
            }
            if(targetPc.hp = 0) {
                pc := array_filter(player.party, p => p.hp > 0);
                if(len(pc) = 0) {
                    combatTurnEnd();
                }
            }
        } else {
            gameMessage(combatRound.name + " misses.", COLOR_MID_GRAY);
        }
    }
}

def findRangeMonster() {
    return array_find(map.monster, e => e.pos[0] = player.x + rangeX - 5 && e.pos[1] = player.y + rangeY - 5 && e.hp > 0);
}

def playerRangeAttack() {
    combatRound := combat.round[combat.roundIndex];
    combatRound.creature["rangeMonster"] := findRangeMonster();
    apUsed := 0;
    if(combatRound.creature["rangeMonster"] != null) {
        success := animateProjectile(
            player.x, player.y,
            combatRound.creature.rangeMonster.pos[0] , combatRound.creature.rangeMonster.pos[1],
            array_map(combatRound.creature.ranged.rangeBlocks, rb => img[rb]),
            true
        );
        if(success) {
            apUsed := playerAttacks(combatRound.creature.rangeMonster, true);
        } else {
            buzzer();
        }
    }
    rangeFinder := false;
    return apUsed;
}

def playerSpellAttack(projectile, damage, bonus, save) {
    combatRound := combat.round[combat.roundIndex];
    combatRound.creature["rangeMonster"] := findRangeMonster();
    apUsed := 0;
    if(combatRound.creature["rangeMonster"] != null) {
        animateProjectile(
            player.x, player.y,
            combatRound.creature.rangeMonster.pos[0] , combatRound.creature.rangeMonster.pos[1],
            array_map(projectile, p => img[p]),
            false
        );
        playerAttacksDam(combatRound.creature.rangeMonster, damage, bonus + getHitMod(combatRound.creature.rangeMonster, save), null);
        apUsed := 3;
    }
    rangeFinder := false;
    return apUsed;
}

def playerAreaSpellAttack(projectile, damage, bonus, radius, save) {
    combatRound := combat.round[combat.roundIndex];
    tx := player.x + rangeX - 5;
    ty := player.y + rangeY - 5;
    animateProjectile(player.x, player.y, tx, ty, array_map(projectile, p => img[p]), false);
    animateBlast(player.x, player.y, tx, ty, radius, img[projectile[0]], m => playerAttacksDam(m, damage, bonus + getHitMod(m, save), null));
    rangeFinder := false;
    return 3;
}

def playerQuakeSpellAttack(projectile, damage, bonus) {
    combatRound := combat.round[combat.roundIndex];
    tx := player.x + rangeX - 5;
    ty := player.y + rangeY - 5;
    animateProjectile(player.x, player.y, tx, ty, array_map(projectile, p => img[p]), false);
    animateQuake();
    array_foreach(map.monster, (i, e) => {
        if(e.hp > 0 && e.pos[0] >= player.x - 6 && e.pos[0] < player.x + 6 && e.pos[1] >= player.y - 6 && e.pos[1] < player.y + 6) {
            playerAttacksDam(e, damage, bonus, null);
        }
    });
    rangeFinder := false;
    return 3;
}

def playerRangeTarget() {
    combatRound := combat.round[combat.roundIndex];
    if(rangeFinder = false && combatRound.creature["ranged"] != null) {
        rangeFinder := true;
        if(combatRound.creature["rangeMonster"] != null) {
            rangeX := combatRound.creature["rangeMonster"].pos[0] - player.x + 5;
            rangeY := combatRound.creature["rangeMonster"].pos[1] - player.y + 5;
            if(rangeX < 0 || rangeX >= 11 || rangeY < 0 || rangeY >= 11) {
                rangeX := 5;
                rangeY := 5;
            }
        } else {
            rangeX := 5;
            rangeY := 5;
        }
        combatRound.creature["rangeMonster"] := null;
    } else {
        buzzer();
    }
}

def playerAttacks(monster, rangedAttack) {
    combatRound := combat.round[combat.roundIndex];
    if(rangedAttack) {
        attacks := [ combatRound.creature.ranged ];
    } else {
        attacks := combatRound.creature.attack; 
    }
    res := { "attackChanged": false };
    array_foreach(attacks, (i, attack) => {
        gameMessage(combatRound.name + " attacks " + monster.monsterTemplate.name + " with " + attack.weapon + "!", COLOR_MID_GRAY);
        if(monster.monsterTemplate.isWeaponEffective(ITEMS_BY_NAME[attack.weapon])) {
            if(playerAttacksDam(monster, attack.dam, attack.bonus, attack.bonusVs) && attack.slot != null) {
                if(decItemLife(combatRound.creature, attack.slot)) {
                    res.attackChanged := true;
                }
            }
        } else {
            gameMessage("The weapon is ineffective!", COLOR_YELLOW);
        }
    });
    if(res.attackChanged) {
        calculateArmor(combatRound.creature);
    }
    return 3;
}

def playerAttacksDam(monster, damage, bonus, bonusVs) {
    combatRound := combat.round[combat.roundIndex];

    # restrict bonus to creature types
    realBonus := bonus;
    if(bonusVs != null && monster.monsterTemplate["type"] != bonusVs) {
        realBonus := 0;
    }
    
    # roll to-hit
    toHit := roll(0, 20) + getToHitBonus(combatRound.creature) + realBonus;
    if(toHit <= monster.monsterTemplate.armor) {
        gameMessage(combatRound.name + " misses.", COLOR_MID_GRAY);
        combatMissSound();
        return false;
    }

    # roll damage
    dam := roll(damage[0], damage[1]) + realBonus;
    monsterTakeDamage(combatRound.creature, monster, dam);

    return true;
}

def monsterTakeDamage(pc, monster, dam) {
    combatRound := combat.round[combat.roundIndex];
    if(dam > 0) {
        gameMessage(monster.monsterTemplate.name + " takes " + dam + " damage!", COLOR_RED);
        combatAttackSound();
        monster.hp := max(monster.hp - dam, 0);
        setMapEffect(combatRound.creature.pos[0], combatRound.creature.pos[1], monster.pos, EFFECT_DAMAGE);
        if(monster.hp = 0) {
            if(pc != null) {
                exp := monster.monsterTemplate.level * 50;
                gainExp(pc, roll(int(exp * 0.7), exp));
            }
            gameMessage(monster.monsterTemplate.name + " dies!", COLOR_RED);
            getBlock(monster.pos[0], monster.pos[1])["blocker"] := null;
            if(monster.monsterTemplate["onDeath"] != null) {
                monster.monsterTemplate.onDeath();
            }
            if(events[mapName]["onMonsterKilled"] != null) {
                events[mapName].onMonsterKilled(monster);
            }
            if(monster.monsterTemplate["drops"] != null) {
                array_foreach(monster.monsterTemplate.drops, (i, name) => {
                    if(name = "coins") {
                        amount := roll(7 * monster.monsterTemplate.level, 10 * monster.monsterTemplate.level);
                        player.coins := player.coins + amount;
                        gameMessage("You find " + amount + " coins!", COLOR_GREEN);
                    } else {
                        if(random() < 0.3 || ITEMS_BY_NAME[name].type = OBJECT_SPECIAL) {
                            gameMessage("You find " + name + "!", COLOR_GREEN);
                            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME[name]);
                        }
                    }
                });
            }
        } else {
            percent := monster.hp / monster.monsterTemplate.startHp;
            if(percent < 0.2) {
                monster.state[STATE_SCARED] := 10;
                gameMessage(monster.monsterTemplate.name + " is critical!", COLOR_RED);
            } else {
                if(percent < 0.5) {
                    gameMessage(monster.monsterTemplate.name + " is wounded!", COLOR_RED);
                }
            }
        }
    } else {
        gameMessage(combatRound.name + " misses.", COLOR_MID_GRAY);
    }
}

def findPath(monster, target) {
    #trace("monster=" + monster.monsterTemplate.name);
    info := {
        "grid": [],
        "start": null,
        "end": null,
    };
    traverseMapAround(
        monster.pos[0], 
        monster.pos[1], 
        FIND_PATH_RADIUS, 
        (px, py, x, y, mapx, mapy, onScreen, mapBlock) => {
            if(len(info.grid) <= x) {
                info.grid[x] := [];                    
            }
            info.grid[x][y] := newGridNode(x, y, canMoveTo(monster.id, mapx, mapy, target["id"], monster.monsterTemplate.wallBlocks) = false);
            if(mapx = monster.pos[0] && mapy = monster.pos[1]) {
                info.start := info.grid[x][y];
            }
            if(mapx = target.pos[0] && mapy = target.pos[1]) {
                info.end := info.grid[x][y];
            }
        }
    );
    if(info.start = null || info.end = null) {
        #trace("fail: start=" + info.start + " end=" + info.end);
        return [];
    }
    #trace("Looking for path, from=" + info.start + " to=" + info.end);
    #start := getTicks();
    path := astarSearch(info.grid, info.start, info.end);
    #trace("astar in " + (getTicks() - start));
    dx := monster.pos[0] - info.start.x;
    dy := monster.pos[1] - info.start.y;
    path := array_map(path, e => {
        return {
            "x": e.x + dx,
            "y": e.y + dy,
        };
    });
    #trace("Found path!");
    #trace("path delta=" + combatRound.pathDx + "," + combatRound.pathDy);
    return path;
}
