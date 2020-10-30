def initDeath() {
}

def renderDeath() {
    clearVideo();
    fillRect(0, 0, 320, 200, COLOR_MID_GRAY);
    drawBezel(5, 5, 315, 40, COLOR_DARK_GRAY, COLOR_LIGHT_GRAY, 1);
    drawText(100, 20, COLOR_YELLOW, COLOR_MID_GRAY, "You have died.");
    drawBezel(5, 50, 315, 160, COLOR_LIGHT_GRAY, COLOR_DARK_GRAY, 3);
    fillRect(6, 51, 315, 160, COLOR_BLACK);
    drawText(40, 55, COLOR_LIGHT_GRAY, COLOR_BLACK, "The din of battle fades and you ");
    drawText(60, 65, COLOR_LIGHT_GRAY, COLOR_BLACK, "succumb to your wounds.");
    drawText(60, 140, COLOR_LIGHT_GRAY, COLOR_BLACK, "Eons pass as your ossified");
    drawText(24, 150, COLOR_LIGHT_GRAY, COLOR_BLACK, "remains become a part of Svaltfen.");
    drawImage(122, 92, img["cand"]);
    drawImage(152, 92, img["bones"]);
    drawImage(180, 92, img["cand"]);
    drawBezel(5, 180, 315, 195, COLOR_DARK_GRAY, COLOR_LIGHT_GRAY, 1);
    drawText(20, 185, COLOR_DARK_GRAY, COLOR_MID_GRAY, "Press SPACE to play again");
}

def deathInput() {
    if(isKeyDown(KeySpace)) {
        while(isKeyDown(KeySpace)) {
        }
        mode := "title";
    }
    if(mode != "death") {
        MODES[mode].init();
        MODES[mode].render();
        updateVideo();
    }
}
