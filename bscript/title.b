titleMode := 0;
savegameFound := null;

def initTitle() {
    titleMode := 0;
    savegameFound := load("savegame.dat");
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

