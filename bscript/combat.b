combat := {
    "monsters": [],
    "round": [],
    "roundIndex": 0,
    "roundCount": 1,
    "playerControl": false,
};

# this is called infrequently from events
def endCombat() {
    gameMode := MOVE;
}

def startCombat() {
    if(gameMode = MOVE && mode != "death") {
        player.party[player.partyIndex].pos[0] := player.x;
        player.party[player.partyIndex].pos[1] := player.y;
        monsters := getLiveMonsters(map.monster);
        if(len(monsters) > 0) {
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

def initCombatRound() {
    if(combat.roundCount > 0) {
        # find any extra monsters
        new_monsters := getLiveMonsters(array_filter(map.monster, m => {
            return array_find_index(combat.monsters, cm => cm.id = m.id) = -1;
        }));
        if(len(new_monsters) > 0) {
            trace("Added " + len(new_monsters) + " new monsters to combat.");
        }
        # add them
        array_foreach(new_monsters, (i, nm) => {
            combat.monsters[len(combat.monsters)] := nm;
        });
    }
    combat.round := [];
    combat.roundIndex := 0;
    combat.roundCount := combat.roundCount + 1;
    array_foreach(combat.monsters, (i, p) => { 
        combat.round[len(combat.round)] := {
            "type": "monster",
            "monster": p,
            "ap": 10,
            "target": null,
            "path": p.path,
            "pathIndex": 0,
            "name": p.monsterTemplate.name,
        };
        # remove the original path after first use
        p.path := []; 
    });
    array_foreach(player.party, (i, p) => { 
        combat.round[len(combat.round)] := {
            "type": "pc",
            "pc": p,
            "ap": 10,
            "name": p.name,
        };
    });
    
    # order by initiative (speed, really)
    sort(combat.round, (a,b) => {
        if(a.type = "monster") {
            aini := a.monster.monsterTemplate.speed;
        } else {
            aini := a.pc.speed;
        }
        if(b.type = "monster") {
            bini := b.monster.monsterTemplate.speed;
        } else {
            bini := b.pc.speed;
        }
        if(aini < bini) {
            return 1;
        } else {
            return -1;
        }
    });

    #clearGameMessages();
    gameMessage("Combat!", COLOR_RED);

    runCombatTurn();
}

def checkCombatDone() {
    pc := array_filter(player.party, p => p.hp > 0);
    if(len(pc) = 0) {
        if(mode != "death") {
            gameMode := MOVE;
            player.partyIndex := 0;
            mode := "death";
            MODES[mode].render();
            updateVideo();
            deathSound();
        }
        return true;
    }
    live_monsters := array_filter(combat.monsters, m => m.visible && m.hp > 0);
    if(len(live_monsters) = 0) {
        gameMessage("Victory!", COLOR_GREEN);
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
    if(combatRound.type = "pc") {
        if(combatRound.pc.hp <= 0) {
            combatTurnEnd();
        } else {
            # trace("SWITCH to " + combatRound.pc.index);
            player.partyIndex := combatRound.pc.index;
            player.x := player.party[player.partyIndex].pos[0];
            player.y := player.party[player.partyIndex].pos[1];

            combat.playerControl := true;
            gameMessage("It is your turn: " + combatRound.pc.name, COLOR_MID_GRAY);
            renderGame();
            updateVideo();
        }
    } else {
        monster := combatRound.monster;
        if(monster.hp <= 0) {
            combatTurnEnd();
        } else {
            combat.playerControl := false;
            renderGame();
            updateVideo();
            while(monster.visible && combatRound.ap > 0) {
                
                # target still valid?
                if(combatRound.target != null) {
                    # target died
                    if(combatRound.target.hp <= 0) {
                        combatRound.target := null;
                        combatRound.pathIndex := len(combatRound.path);
                    }

                    # if target moved: retarget
                    if(combatRound.target != null && len(combatRound.path) > 0) {
                        lastNode := combatRound.path[len(combatRound.path) - 1];
                        if(lastNode.x != combatRound.target.pos[0] || lastNode.y != combatRound.target.pos[1]) {
                            combatRound.pathIndex := len(combatRound.path);
                        }
                    }
                }

                apUsed := 1;
                near_pc := array_find(player.party, pc => {
                    if(pc.hp <= 0) {
                        return false;
                    }
                    d := [
                        monster.pos[0] - pc.pos[0],
                        monster.pos[1] - pc.pos[1]
                    ];
                    near := abs(d[0]) <= monster.monsterTemplate.range && abs(d[1]) <= monster.monsterTemplate.range;
                    if(near && monster.monsterTemplate.range > 1) {
                        near := checkProjectile(monster.pos[0], monster.pos[1], pc.pos[0], pc.pos[1]);
                    }
                    if(monster.target != null) {
                        return pc.name = monster.target.name && near;
                    } else {
                        return near;
                    }
                });
                if(near_pc != null) {
                    attackMonster(near_pc);
                    apUsed := monster.monsterTemplate.attackAp;
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
                            combatRound.target := choose(array_filter(player.party, p => p.hp > 0));
                            if(combatRound.target != null) {
                                #trace("new target: finding path target=" + combatRound.target.index + " from=" + monster.pos + " to=" + combatRound.target.pos);
                                combatRound.path := findPath(monster, combatRound.target);
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

                combatRound.ap := combatRound.ap - apUsed;

                sleep(250);
                renderGame();
                updateVideo();
            }
            combatTurnEnd();
        }
    }
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
    live_monsters := array_filter(combat.monsters, m => m.visible && m.hp > 0);
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

def getLiveMonsters(monsters) {
    return array_filter(monsters, m => { 
        if(m.visible && m.hp > 0) {
            pc := array_find(player.party, pc => abs(m.pos[0] - pc.pos[0]) <= 6 && abs(m.pos[1] - pc.pos[1]) <= 6);
            if(pc != null) {
                m["path"] := findPath(m, pc);
                return len(m.path) > 0;
            }
        }
        return false;
    });
}

def canMoveTo(monster, mx, my) {
    if(mx >= 0 && my >= 0 && mx < map.width && my < map.height) {
        block := blocks[getBlock(mx, my).block];
        blocked := block.blocking;
        if(blocked = false) {
            npc := array_find(map.npc, p => p.pos[0] = mx && p.pos[1] = my);
            blocked := npc != null;
        }
        if(blocked = false) {
            m := array_find(map.monster, p => p.pos[0] = mx && p.pos[1] = my && p.id != monster.id && p.hp > 0);
            blocked := m != null;
        }
        return blocked = false;
    }
    return false;
}

def moveMonster() {
    combatRound := combat.round[combat.roundIndex];
    monster := combatRound.monster;

    moved := false;
    pathNode := combatRound.path[combatRound.pathIndex];
    #trace("At " + monster.pos[0] + "," + monster.pos[1] + " trying: " + nx + "," + ny);
    if(canMoveTo(monster, pathNode.x, pathNode.y)) {
        monster.pos[0] := pathNode.x;
        monster.pos[1] := pathNode.y;
        combatRound.pathIndex := combatRound.pathIndex + 1;
        moved := true;
        #trace("...yes");
    } else {
        #trace("...no");
    }

    if(moved) {
        #gameMessage(monster.monsterTemplate.name + " moves", COLOR_MID_GRAY);
        stepSound();
    } else {
        gameMessage(monster.monsterTemplate.name + " waits", COLOR_MID_GRAY);        
    }
    return moved;
}

def attackMonster(targetPc) {
    combatRound := combat.round[combat.roundIndex];
    monster := combatRound.monster;

    if(monster.monsterTemplate.range > 1) {
        if(monster.monsterTemplate["rangeBlocks"] = null) {
            projectile := [ img["arrow"], img["arrow2"] ];
        } else {
            projectile := array_map(monster.monsterTemplate.rangeBlocks, p => img[p]);
        }
        success := animateProjectile(
            monster.pos[0], monster.pos[1],
            targetPc.pos[0], targetPc.pos[1],
            projectile
        );
        if(success = false) {
            return 1;
        }
    }

    gameMessage(monster.monsterTemplate.name + " attacks " + targetPc.name + "!", COLOR_MID_GRAY);

    # roll to-hit
    toHit := roll(0, 20) + monster.monsterTemplate.armor;
    if(toHit <= targetPc.armor) {
        gameMessage(monster.monsterTemplate.name + " misses.", COLOR_MID_GRAY);
        combatMissSound();
        return 1;
    }

    # roll damage
    dam := roll(monster.monsterTemplate.attack[0], monster.monsterTemplate.attack[1]);
    if(dam > 0) {
        gameMessage(targetPc.name + " takes " + dam + " damage!", COLOR_RED);
        combatAttackSound();
        targetPc.hp := max(targetPc.hp - dam, 0);
        setMapEffect(monster.pos[0], monster.pos[1], targetPc.pos, EFFECT_DAMAGE);
        if(targetPc.hp = 0) {
            gameMessage(targetPc.name + " dies!", COLOR_RED);
            pc := array_filter(player.party, p => p.hp > 0);
            if(len(pc) = 0) {
                combatTurnEnd();
            } else {
                # return dead pc-s equipment to pool so someone else can use it
                array_foreach(SLOTS, (i, slot) => {
                    if(targetPc.equipment[slot] != null) {
                        player.inventory[len(player.inventory)] := targetPc.equipment[slot];
                        targetPc.equipment[slot] := null;
                    }
                });
                calculateArmor(targetPc);
            }
        }
    } else {
        gameMessage(monster.monsterTemplate.name + " misses.", COLOR_MID_GRAY);
    }
}

def playerRangeAttack() {
    combatRound := combat.round[combat.roundIndex];
    combatRound.pc["rangeMonster"] := array_find(map.monster, e => e.pos[0] = player.x + rangeX - 5 && e.pos[1] = player.y + rangeY - 5 && e.hp > 0);
    apUsed := 0;
    if(combatRound.pc["rangeMonster"] != null) {
        success := animateProjectile(
            player.x, player.y,
            combatRound.pc.rangeMonster.pos[0] , combatRound.pc.rangeMonster.pos[1],
            [ img["arrow"], img["arrow2"] ]
        );
        if(success) {
            apUsed := playerAttacks(combatRound.pc.rangeMonster, true);
        } else {
            buzzer();
        }
    }
    rangeFinder := false;
    return apUsed;
}

def checkProjectile(srcX, srcY, dstX, dstY) {
    # check that a projectile could reach the target
    mx := dstX - srcX;
    my := dstY - srcY;
    amx := abs(mx);
    amy := abs(my);
    steps := max(amx, amy);
    if(amx > amy) {
        dx := mx / amx;
        dy := my / amx;
    } else {
        dy := my / amy;
        dx := mx / amy;
    }

    step := 0;
    success := true;
    while(success && step < steps) {
            # move arrow
            srcX := srcX + dx;
            srcY := srcY + dy;
            step := step + 1;

            # did we hit a wall?
            block := blocks[getBlock(round(srcX), round(srcY)).block];
            success := block.light = false;
    }
    return success;
}

# assumes screen is centered on src
def animateProjectile(srcX, srcY, dstX, dstY, arrowImages) {
    # animate arrow path
    arrowX := TILE_W * 5;
    arrowY := TILE_H * 5;
    ex := (dstX - srcX + 5) * TILE_W;
    ey := (dstY - srcY + 5) * TILE_H;
    mx := ex - arrowX;
    my := ey - arrowY;
    amx := abs(mx);
    amy := abs(my);
    steps := max(amx, amy);
    flipX := 0;
    flipY := 0;
    imgIndex := 0;
    if(amx > amy) {
        dx := mx / amx;
        dy := my / amx;
        if(dx > 0) {
            flipX := 1;
        }
    } else {
        imgIndex := 1;
        dy := my / amy;
        dx := mx / amy;
        if(dy > 0) {
            flipY := 1;
        }
    }

    setSprite(ARROW_SPRITE, arrowImages);

    step := 0;
    success := true;
    arrowFireSound();
    t := 0;
    speed := 2;
    while(success && step < steps) {
        if(getTicks() > t) {
            t := getTicks() + 0.01;
            drawSprite(arrowX + 5 + TILE_W/2, arrowY + 5 + TILE_H/2, ARROW_SPRITE, imgIndex, flipX, flipY);

            # move arrow
            arrowX := arrowX + dx * speed;
            arrowY := arrowY + dy * speed;
            step := step + speed;

            # did we hit a wall?
            block := blocks[getBlock(round(arrowX / TILE_W) - 5 + srcX, round(arrowY / TILE_H) - 5 + srcY).block];
            success := block.light = false;
        }

        updateVideo();
    }
    delSprite(ARROW_SPRITE);
    return success;
}

def playerRangeTarget() {
    combatRound := combat.round[combat.roundIndex];
    if(rangeFinder = false && combatRound.pc["ranged"] != null) {
        rangeFinder := true;                        
        if(combatRound.pc["rangeMonster"] != null) {
            rangeX := combatRound.pc["rangeMonster"].pos[0] - player.x + 5;
            rangeY := combatRound.pc["rangeMonster"].pos[1] - player.y + 5;
            if(rangeX < 0 || rangeX >= 11 || rangeY < 0 || rangeY >= 11) {
                rangeX := 5;
                rangeY := 5;
            }
        } else {
            rangeX := 5;
            rangeY := 5;
        }
        combatRound.pc["rangeMonster"] := null;
    } else {
        buzzer();
    }
}

def playerAttacks(monster, rangedAttack) {
    combatRound := combat.round[combat.roundIndex];
    if(rangedAttack) {
        attacks := [ combatRound.pc.ranged ];
    } else {
        attacks := combatRound.pc.attack; 
    }
    res := { "attackChanged": false };
    array_foreach(attacks, (i, attack) => {
        gameMessage(combatRound.pc.name + " attacks " + monster.monsterTemplate.name + " with " + attack.weapon + "!", COLOR_MID_GRAY);
        if(playerAttacksDam(monster, attack.dam, attack.bonus) && attack.slot != null) {
            if(decItemLife(combatRound.pc, attack.slot)) {
                res.attackChanged := true;
            }
        }
    });
    if(res.attackChanged) {
        calculateArmor(combatRound.pc);
    }
    return 3;
}

def playerAttacksDam(monster, damage, bonus) {
    combatRound := combat.round[combat.roundIndex];

    # roll to-hit
    toHit := roll(0, 20) + getToHitBonus(combatRound.pc) + bonus;
    if(toHit <= monster.monsterTemplate.armor) {
        gameMessage(combatRound.pc.name + " misses.", COLOR_MID_GRAY);
        combatMissSound();
        return false;
    }

    # roll damage
    dam := roll(damage[0], damage[1]) + bonus;
    if(dam > 0) {
        gameMessage(monster.monsterTemplate.name + " takes " + dam + " damage!", COLOR_RED);
        combatAttackSound();
        monster.hp := max(monster.hp - dam, 0);
        setMapEffect(combatRound.pc.pos[0], combatRound.pc.pos[1], monster.pos, EFFECT_DAMAGE);
        if(monster.hp = 0) {
            exp := monster.monsterTemplate.level * 50;
            gainExp(combatRound.pc, roll(int(exp * 0.7), exp));
            gameMessage(monster.monsterTemplate.name + " dies!", COLOR_RED);
            if(monster.monsterTemplate["onDeath"] != null) {
                monster.monsterTemplate.onDeath();
            }
            if(events[mapName]["onMonsterKilled"] != null) {
                events[mapName].onMonsterKilled(monster);
            }
            if(monster.monsterTemplate["drops"] != null) {
                array_foreach(monster.monsterTemplate.drops, (i, name) => {
                    if(random() < 0.3) {
                        if(name = "coins") {
                            amount := roll(7 * monster.monsterTemplate.level, 10 * monster.monsterTemplate.level);
                            player.coins := player.coins + amount;
                            gameMessage("You find " + amount + " coins!", COLOR_GREEN);
                        } else {
                            gameMessage("You find " + name + "!", COLOR_GREEN);
                            player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME[name]);
                        }
                    }
                });
            }
        } else {
            percent := monster.hp / monster.monsterTemplate.startHp;
            if(percent < 0.2) {
                gameMessage(monster.monsterTemplate.name + " is critical!", COLOR_RED);
            } else {
                if(percent < 0.5) {
                    gameMessage(monster.monsterTemplate.name + " is wounded!", COLOR_RED);
                }
            }
        }
    } else {
        gameMessage(combatRound.pc.name + " misses.", COLOR_MID_GRAY);
    }
    return true;
}

def findPath(monster, target) {
    #trace("monster=" + monster + " target=" + target);
    r := LIGHT_RADIUS * 2 - 1;
    info := {
        "grid": [],
        "start": null,
        "end": null,
    };
    traverseMapAround(
        monster.pos[0], 
        monster.pos[1], 
        r, 
        (px, py, x, y, mapx, mapy, onScreen, mapBlock) => {
            if(len(info.grid) <= x) {
                info.grid[x] := [];                    
                    info.grid[x] := [];                    
                info.grid[x] := [];                    
                    info.grid[x] := [];                    
                info.grid[x] := [];                    
            }
            info.grid[x][y] := newGridNode(x, y, canMoveTo(monster, mapx, mapy) = false);
            if(mapx = monster.pos[0] && mapy = monster.pos[1]) {
                info.start := info.grid[x][y];
            }
            if(mapx = target.pos[0] && mapy = target.pos[1]) {
                info.end := info.grid[x][y];
            }
        }
    );
    if(info.start = null || info.end = null) {
        return [];
    }
    #trace("Looking for path, from=" + info.start + " to=" + info.end);
    path := astarSearch(info.grid, info.start, info.end);   
    dx := monster.pos[0] - info.start.x;
    dy := monster.pos[1] - info.start.y;
    path := array_map(path, e => {
        return {
            "x": e.x + dx,
            "y": e.y + dy,
        };
    });
    #trace("Found path=" + array_map(combatRound.path, p => p.pos));
    #trace("path delta=" + combatRound.pathDx + "," + combatRound.pathDy);
    return path;
}
