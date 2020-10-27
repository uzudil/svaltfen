titleMode := 0;
savegameFound := null;

fr := {
    "N": 0,
    "C2": 65.41,
    "C#2": 69.30,
    "D2": 73.42,
    "D#2": 77.78,
    "E2": 82.41,
    "F2": 87.31,
    "F#2": 92.50,
    "G2": 98.00,
    "G#2": 103.83,
    "A2": 110.00,
    "A#2": 116.54,
    "B2": 123.47,
    "C3": 130.81,
    "C#3": 138.59,
    "D3": 146.83,
    "D#3": 155.56,
    "E3": 164.81,
    "F3": 174.61,
    "F#3": 185.00,
    "G3": 196.00,
    "G#3": 207.65,
    "A3": 220.00,
    "A#3": 233.08,
    "B3": 246.94,
    "C4": 261.63,
    "C#4": 277.18,
    "D4": 293.66,
    "D#4": 311.13,
    "E4": 329.63,
    "F4": 349.23,
    "F#4": 369.99,
    "G4": 392.00,
    "G#4": 415.30,
    "A4": 440.00,
    "A#4": 466.16,
    "B4": 493.88,
    "C5": 523.25,
    "C#5": 554.37,
    "D5": 587.33,
    "D#5": 622.25,
    "E5": 659.25,
    "F5": 698.46,
    "F#5": 739.99,
    "G5": 783.99,
    "G#5": 830.61,
    "A5": 880.00,
    "A#5": 932.33,
    "B5":	987.77,
};

const MUSIC_SPEED = 0.275;
# used: https://onlinesequencer.net/
bass :=  "0 F3 1 0;1 G3 1 0;2 G#3 1 0;3 G3 1 0;4 F3 1 0;5 F3 1 0;6 D#3 2 0;16 F3 1 0;17 G3 1 0;18 G#3 1 0;19 G3 1 0;20 F3 1 0;21 F3 1 0;22 D#3 2 0;8 A3 1 0;9 G#3 1 0;10 G3 1 0;12 A3 1 0;13 G#3 1 0;14 G3 1 0;24 D3 1 0;26 E3 1 0;27 F#3 1 0;28 D#3 3 0;31 N 18 0";
music := "0 F4 1 0;1 C5 2 0;4 C5 1 0;3 C5 1 0;5 B4 1 0;6 C5 1 0;7 B4 1 0;8 A4 2 0;10 A4 1 0;11 A4 1 0;12 B4 1 0;13 G4 2 0;16 F4 1 0;17 C5 2 0;20 C5 1 0;19 C5 1 0;21 B4 1 0;22 C5 1 0;23 B4 1 0;24 A4 2 0;26 A4 1 0;27 C5 1 0;28 B4 1 0;29 D5 2 0;32 F4 1 0;33 G4 1 0;34 A4 1 0;35 B4 1 0;36 F5 2 0;38 E5 1 0;39 F5 1 0;40 E5 1 0;41 D5 1 0;42 B4 1 0;43 B4 1 0;45 E4 2 0;47 N 2 0";

def addNotes(ch, notesStr) {
    notes := split(notesStr, ";");
    i := 0;
    c := 0;
    while(i < len(notes)) {
        s := split(notes[i], " ");
        playSound(ch, fr[s[1]], int(s[2]) * MUSIC_SPEED);
        #playSound(ch, 0, 0.1 * MUSIC_SPEED);
        c := c + int(s[2]);
        i := i + 1;
    }
    # trace("channel=" + ch + " notes=" + c);
}

def initTitle() {
    titleMode := 0;
    savegameFound := load("savegame.dat");

    clearSound(0);
    clearSound(1);
    pauseSound(0, true);
    pauseSound(1, true);
    addNotes(0, bass);
    addNotes(1, music);
    loopSound(0, true);
    loopSound(1, true);
    pauseSound(0, false);
    pauseSound(1, false);
}

def drawTitleScene() {
    fillRect(6, 51, 315, 160, COLOR_LIGHT_BLUE);
    range(0, 20, 1, i => {
        x := 20 + random() * 280;
        y := 70 + random() * 60;
        range(0, 30, 1, t => {
            fillCircle(x + (random() * 20) - 10, y + (random() * 20) - 10, random() * 5 + 3, COLOR_WHITE);
        });
    });

    x := 6;
    y := 120;
    range(6, 315, 1, x => {
        if(random() > 0.5) {
            oy := y;
            y := y + (random() * 2) - 1;
            if(y < 100 || y > 140) {
                y := oy;
            }
        }
        drawLine(x, y, x, 160, COLOR_TEAL);
        x := x + 1;
    });
    trees := [];
    range(0, 25, 1, i => {
        trees[len(trees)] := [
            12 + random() * 285,
            120 + random() * 20,
        ];
    });
    sort(trees, (a, b) => {
        if(a[1] > b[1]) {
            return 1;
        } else {
            return -1;
        }
    });
    array_foreach(trees, (i, tree) => {
        x := tree[0];
        y := tree[1];
        obj := img["oak"];
        if(i = 10) {
            obj := img["castle"];
        }
        if(i = 20) {
            obj := img["temple"];
        }
        drawImage(x, y, obj);
    });
}

def renderTitle() {
    clearVideo();
    fillRect(0, 0, 320, 200, COLOR_MID_GRAY);

    if(titleMode = 0) {
        drawBezel(5, 5, 315, 40, COLOR_DARK_GRAY, COLOR_LIGHT_GRAY, 1);
        drawBezel(5, 50, 315, 160, COLOR_LIGHT_GRAY, COLOR_DARK_GRAY, 3);
        drawTitleScene();
        drawBezel(5, 170, 315, 195, COLOR_DARK_GRAY, COLOR_LIGHT_GRAY, 1);

        drawText(70, 20, COLOR_YELLOW, COLOR_MID_GRAY, "The Curse of Svaltfen");
        drawText(220, 175, COLOR_DARK_GRAY, COLOR_MID_GRAY, "Gabor Torok");
        drawText(220, 185, COLOR_DARK_GRAY, COLOR_MID_GRAY, "(c) MMXX");
        drawLine(210, 170, 210, 194, COLOR_LIGHT_GRAY);
        drawLine(211, 171, 211, 195, COLOR_DARK_GRAY);
        if(savegameFound = null) {
            drawText(20, 175, COLOR_DARK_GRAY, COLOR_MID_GRAY, "Press SPACE to start");
        } else {
            drawText(10, 175, COLOR_DARK_GRAY, COLOR_MID_GRAY, "Press SPACE to continue");
            drawText(10, 185, COLOR_DARK_GRAY, COLOR_MID_GRAY, "Or, Esc to start over");
        }
    }
    if(titleMode = 1) {
        drawBezel(5, 5, 315, 195, COLOR_LIGHT_GRAY, COLOR_DARK_GRAY, 3);
        fillRect(5, 5, 315, 195, COLOR_BLACK);

        drawText(10, 10, COLOR_MID_GRAY, COLOR_BLACK, "You see a faint light coming closer.");
        drawText(10, 20, COLOR_MID_GRAY, COLOR_BLACK, "Memories from past lives echo in");
        drawText(10, 30, COLOR_MID_GRAY, COLOR_BLACK, "your brain.");

        drawText(10, 50, COLOR_LIGHT_GRAY, COLOR_BLACK, "I have lived before...");
        drawText(10, 60, COLOR_LIGHT_GRAY, COLOR_BLACK, "Walked the earth many eons ago...");

        drawText(10, 80, COLOR_MID_GRAY, COLOR_BLACK, "You remember completing tasks of");
        drawText(10, 90, COLOR_MID_GRAY, COLOR_BLACK, "great evil.");
        drawText(10, 100, COLOR_MID_GRAY, COLOR_BLACK, "But it was necessary then...");
        drawText(10, 110, COLOR_MID_GRAY, COLOR_BLACK, "...And it is so again.");

        drawText(10, 130, COLOR_MID_GRAY, COLOR_BLACK, "You awake then fully, in darkness,");
        drawText(10, 140, COLOR_MID_GRAY, COLOR_BLACK, "somewhere underground.");

        drawText(20, 185, COLOR_DARK_GRAY, COLOR_BLACK, "Press SPACE to start");
    }
}

def titleInput() {
    if(isKeyPress(KeyE)) {
        mode := "editor";
    }
    startGame := false;
    if(isKeyPress(KeyEscape)) {
        setVideoMode(0);
        print("This will erase your progress!");
        yn := input("Are you sure? (Y/N) ");
        setVideoMode(1);
        if(yn = "Y" || yn = "y") {
            erase("savegame.dat");
            erase("*.mut");
            startGame := true;
            savegameFound := null;
        }
    }
    if(isKeyPress(KeySpace)) {
        startGame := true;
    }
    if(startGame) {
        titleMode := titleMode + 1;
        if(savegameFound != null || titleMode > 1) {
            mode := "game";
            clearSound(0);
            clearSound(1);
            loopSound(0, false);
            loopSound(1, false);
        } else {
            if(titleMode = 1) {
                setVideoMode(0);
                print("By what name will you be known?");
                playerName := input("Name: ");
                setVideoMode(1);
            }
        }
    }
    if(mode != "title") {
        MODES[mode].init();
    }
}

