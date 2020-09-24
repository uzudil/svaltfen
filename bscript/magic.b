def createFood(n) {
    range(0, n, 1, i => {
        player.inventory[len(player.inventory)] := itemInstance(getRandomItem([OBJECT_FOOD,OBJECT_DRINK], 10));
    });
    gameMessage("Your magic has created food and drink!", COLOR_GREEN);
}

SPELLS := [
    [
        { "name": "Party rations", "onParty": self => createFood(5), },
        { "name": "Minor Healing", "onPc": (self, pc) => gainHp(pc, 10), },
        { "name": "Protect Ally", "onPc": (self, pc) => setState(pc, STATE_SHIELD, 150), },
    ],
    [
        { "name": "Magic Arrow" },
        { "name": "Cure Poison", "onPc": (self, pc) => setState(pc, STATE_POISON, 0) },
        { 
            "name": "Cast Light",  
            "onParty": self => {
                if(player.light = 1) {
                    player.inventory[len(player.inventory)] := itemInstance(ITEMS_BY_NAME["Torch"]);
                    pc := player.party[0];
                    slot := SLOT_LEFT_HAND;
                    if(pc.equipment[slot] != null) {
                        slot := SLOT_RIGHT_HAND;
                    }
                    pcDonItem(pc, len(player.inventory) - 1, slot);
                    gameMessage("A toch appears in your hand!", COLOR_GREEN);
                } else {
                    gameMessage("Your magic fizzles and nothing happens.", COLOR_MID_GRAY);
                }
            },
        },
        { "name": "Wall of Force" },
    ],
    [
        { "name": "Party feast", "onParty": self => createFood(10), },        
        { "name": "Full Healing", "onPc": (self, pc) => gainHp(pc, pc.level * pc.startHp), },
        { "name": "Remember Location" },
        { "name": "Return to Location" },
        { "name": "Reveal Secrets" },
    ],
    [
        { "name": "Remove Curse", "onPc": (self, pc) => setState(pc, STATE_CURSE, 0) },
        { "name": "Heal All", "onParty": self => array_foreach(player.party, (i, pc) => gainHp(pc, pc.level * pc.startHp)), },
        { "name": "Protect All", "onParty": self => array_foreach(player.party, (i, pc) => setState(pc, STATE_SHIELD, 150)), },
        { "name": "Summon Monster" },
        { "name": "Telekinesis" },
        { "name": "View Map" },
    ],
    [
        { "name": "Fireball" },
        { "name": "Command Monster" },
        { "name": "Free from Charm", "onPc": (self, pc) => setState(pc, STATE_CHARM, 0) },
        { "name": "Bless Party", "onParty": self => array_foreach(player.party, (i, pc) => setState(pc, STATE_BLESS, 150)), },
    ],
    [
        { "name": "Petrification" },
        { "name": "Cure Paralysis", "onPc": (self, pc) => setState(pc, STATE_PARALYZE, 0), },
        { "name": "Summon Demon" },
        { "name": "Lightning Strike" },
        { "name": "Invisibility", "onPc": (self, pc) => setState(pc, STATE_INVISIBLE, 150), },
    ],
    [
        { "name": "Resurrection", "onPc": (self, pc) => resurrect(pc), },
        { "name": "Earthquake" },
        { "name": "Cure All Ailments", "onParty": self => array_foreach(player.party, (i, pc) => cureAilments(pc)), },
    ],
];
SPELLS_BY_NAME := {};

def initMagic() {
    SPELLS_BY_NAME := array_reduce(SPELLS, {}, (d, level) => { array_foreach(level, (i, s) => { d[s.name] := s; }); return d; });
}
