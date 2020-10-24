def initWin() {
}

def renderWin() {
    clearVideo();
    fillRect(0, 0, 320, 200, COLOR_MID_GRAY);
    drawBezel(5, 5, 315, 40, COLOR_DARK_GRAY, COLOR_LIGHT_GRAY, 1);
    drawText(15, 20, COLOR_YELLOW, COLOR_MID_GRAY, "The chanting of the sages fades away.");

    drawBezel(5, 50, 315, 170, COLOR_LIGHT_GRAY, COLOR_DARK_GRAY, 3);
    fillRect(6, 51, 315, 170, COLOR_BLACK);
    if(getGameState("game_win") != "sky") {
        drawText(20, 55, COLOR_WHITE, COLOR_BLACK, "You find yourself enveloped in");
        drawText(20, 65, COLOR_WHITE, COLOR_BLACK, "bright light.");
        drawImage(122, 92, img["oak"]);
        drawImage(152, 92, img["fountain"]);
        drawImage(180, 92, img["oak"]);
    } else {
        drawText(20, 55, COLOR_WHITE, COLOR_BLACK, "You find yourself in a large cave,");
        drawText(20, 65, COLOR_WHITE, COLOR_BLACK, "lit by pools of lava.");
        drawImage(122, 92, img["cand"]);
        drawImage(152, 92, img["lava"]);
        drawImage(180, 92, img["cand"]);
    }
    drawText(20, 150, COLOR_WHITE, COLOR_BLACK, "Your adventures in Svaltfen have");
    drawText(20, 160, COLOR_WHITE, COLOR_BLACK, "come to an end.");


    drawBezel(5, 180, 315, 195, COLOR_DARK_GRAY, COLOR_LIGHT_GRAY, 1);
    drawText(20, 185, COLOR_DARK_GRAY, COLOR_MID_GRAY, "Press SPACE to exit");
}

def winInput() {
    if(isKeyDown(KeySpace)) {
        while(isKeyDown(KeySpace)) {
        }
        exit();
    }
    if(mode != "win") {
        MODES[mode].init();
        MODES[mode].render();
        updateVideo();
    }
}
