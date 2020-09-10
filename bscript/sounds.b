def buzzer() {
    playSounds(0, [ 235, 0.2, 215, 0.1 ]);
}

def stepSound() {
    playSound(0, 100, 0.05);
}

def combatMissSound() {
    playSounds(0, [ 550, 0.02, 470, 0.02, 420, 0.02, 350, 0.1 ]);
}

def combatAttackSound() {
    playSounds(0, [ 360, 0.02, 420, 0.02, 470, 0.02, 550, 0.02, 900, 0.02 ]);
}

def combatStartSound() {
    playSounds(0, [ 500, 0.1, 0, 0.1, 500, 0.1, 570, 0.35 ]);
    playSounds(1, [ 520, 0.1, 0, 0.1, 520, 0.1, 580, 0.35 ]);
}

def combatEndSound() {
    playSounds(0, [ 500, 0.075, 0, 0.05, 500, 0.075, 0, 0.25, 500, 0.1, 0, 0.05, 570, 0.35 ]);
    playSounds(1, [ 520, 0.075, 0, 0.05, 520, 0.075, 0, 0.25, 520, 0.1, 0, 0.05, 580, 0.35 ]);
}

def actionSound() {
    playSound(0, 280, 0.075);
    playSound(1, 310, 0.1);
}

def arrowFireSound() {
    playSound(0, 1200, 0.05);
    playSound(1, 1240, 0.075);
}

def equipmentFailSound(n) {
    i := 0;
    while(i < n) {
        playSounds(0, [ 350, 0.025, 380, 0.025,  420, 0.025, 450, 0.025, 480, 0.025, 0, 0.05 ]);
        playSounds(1, [ 360, 0.025, 390, 0.025,  430, 0.025, 460, 0.025, 490, 0.025, 0, 0.05 ]);
        i := i + 1;
    }
}

def levelUpSound() {
    playSounds(0, [ 500, 0.05, 550, 0.05, 600, 0.05, 650, 0.05, 700, 0.05, 750, 0.05, 800, 0.05, 900, 0.15, 0, 0.1, 900, 0.15 ]);
    playSounds(1, [ 250, 0.15, 280, 0.15, 250, 0.15, 280, 0.15, 300, 0.45 ]);
}

def deathSound() {
    playSounds(0, [ 320, 0.5, 300, 0.5, 280, 0.5, 0, 0.2, 200, 0.5, 0, 0.2, 200, 0.2, 220, 0.2, 200, 0.2, 220, 0.2, 200, 1 ]);
    playSounds(1, [ 310, 0.5, 290, 0.5, 270, 0.5, 0, 0.2, 210, 0.5 ]);
}

def playSounds(channel, notes) {
    range(0, len(notes), 2, i => playSound(channel, notes[i], notes[i + 1]));
}
