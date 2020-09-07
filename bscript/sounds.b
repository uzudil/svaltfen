def buzzer() {
    playSound(0, 235, 0.2);
    playSound(0, 215, 0.1);
}

def stepSound() {
    playSound(0, 100, 0.05);
}

def combatMissSound() {
    playSound(0, 100, 0.05);
}

def combatAttackSound() {
    playSound(0, 360, 0.1);
    playSound(1, 380, 0.2);
}

def combatStartSound() {
    playSound(0, 500, 0.1);
    playSound(1, 520, 0.1);
    playSound(0, 0, 0.1);
    playSound(1, 0, 0.1);
    playSound(0, 500, 0.1);
    playSound(1, 520, 0.1);
    playSound(0, 570, 0.3);
    playSound(1, 580, 0.3);
}

def combatEndSound() {
    i := 0;
    while(i < 3) {
        playSound(0, 500, 0.2);
        playSound(1, 520, 0.2);
        playSound(0, 0, 0.2);
        playSound(1, 0, 0.2);
        i := i + 1;
    }
    playSound(0, 570, 0.5);
    playSound(1, 580, 0.5);
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
        playSound(0, 350, 0.05);
        playSound(0, 0, 0.05);
        i := i + 1;
    }
}

def levelUpSound() {
    playSound(1, 0, 0.15);
    playSound(1, 750, 0.25);
    playSound(1, 700, 0.15);
    playSound(1, 800, 0.15);
    playSound(1, 0, 0.15);
    playSound(1, 800, 0.25);

    playSound(2, 0, 0.15);
    playSound(2, 770, 0.25);
    playSound(2, 720, 0.15);
    playSound(2, 820, 0.15);
    playSound(2, 0, 0.15);
    playSound(2, 820, 0.25);
}
