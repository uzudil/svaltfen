const STEPS_PER_HOUR = 300;
const STATE_STEPS = 100;
const STEP_DELTA_OVERLAND = 20;
const STEP_DELTA = 1;
const HOURS_PER_DAY = 24;
const WEEK_DAYS = [ "Argon", "Belten", "Creg", "Dactu", "Ened", "Farne", "Grened" ];
calendarTic := 0;
const STATE_TICS = 5;

def initCalendar() {
    if(player["calendar"] = null) {
        player["calendar"] := {
            "day": 0,
            "hour": 9,
            "step": 0,
            "light": 0,
            "stateStep": 0,
        };
        calendarLight();
    }
}

def calendarLight() {
    if(player.calendar.hour > 21 || player.calendar.hour <= 3) {
        player.calendar.light := 1;
    } else {
        if(player.calendar.hour > 18 || player.calendar.hour <= 6) {
            player.calendar.light := 3;
        } else {
            if(player.calendar.hour > 15 || player.calendar.hour <= 9) {
                player.calendar.light := 5;
            } else {
                player.calendar.light := 10;
            }
        }
    }
}

def getStepDelta() {
    if(isOverlandMap()) {
        return STEP_DELTA_OVERLAND;
    } else {
        return STEP_DELTA;
    }
}

def calendarString() {
    mins := int(60 * (player.calendar.step / STEPS_PER_HOUR));
    if(mins < 10) {
        mins := "0" + mins;
    }
    ampm := "";
    if(player.calendar.hour >= 12) {
        ampm := "PM";
    }
    hour := player.calendar.hour;
    if(hour = 0) {
        hour := 12;
    } else {
        if(hour > 12) {
            hour := hour - 12;
        }
    }
    return WEEK_DAYS[player.calendar.day % len(WEEK_DAYS)] + " " + hour + ":" + mins + ampm;
}

def calendarStep() {
    calendarTic := calendarTic + 1;
    if(calendarTic > STATE_TICS) {
        calendarTic := 0;
        ageState("step");
    }
    player.calendar.step := player.calendar.step + getStepDelta();
    if(abs(player.calendar.step - player.calendar.stateStep) > STATE_STEPS) {
        player.calendar.stateStep := player.calendar.step;
        ageState("age");
    } 
    if(player.calendar.step >= STEPS_PER_HOUR) {
        player.calendar.step := 0;
        player.calendar.hour := player.calendar.hour + 1;
        if(player.calendar.hour >= HOURS_PER_DAY) {
            player.calendar.hour := 0;
            player.calendar.day := player.calendar.day + 1;
            resetSpellCount();
        }
        calendarLight();
    }
}
