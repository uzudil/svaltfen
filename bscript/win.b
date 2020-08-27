def initWin() {
}

def renderWin() {
    clearVideo();
    drawText(20, 30, COLOR_WHITE, COLOR_BLACK, "The chanting of the sages fades away.");
    if(getGameState("game_win") = "sky") {
        drawText(20, 40, COLOR_WHITE, COLOR_BLACK, "You find yourself enveloped in bright");
        drawText(20, 50, COLOR_WHITE, COLOR_BLACK, "light.");        
    } else {
        drawText(20, 40, COLOR_WHITE, COLOR_BLACK, "You find yourself in a large cave,");
        drawText(20, 50, COLOR_WHITE, COLOR_BLACK, "lit by pools of lava.");        
    }
    drawText(20, 150, COLOR_WHITE, COLOR_BLACK, "Your adventures in Svaltfen have");
    drawText(20, 160, COLOR_WHITE, COLOR_BLACK, "come to an end.");

    drawText(20, 185, COLOR_DARK_GRAY, COLOR_BLACK, "Press SPACE to exit");
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
