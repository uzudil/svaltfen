
const events_ashnar3 = {
    "onEnter": self => {
        gameMessage("The upper level of the Library at Ashnar", COLOR_LIGHT_BLUE);
    },
    "onConvo": (self, n) => {
        if(n.name = "Varten") {
            return {
                "": "Look a visitor!",
            };
        }
        return null;
    },
};
