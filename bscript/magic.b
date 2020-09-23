SPELLS := [
    [
        { "name": "Party rations" },
        { "name": "Minor Healing" },
        { "name": "Protect Ally" },
    ],
    [
        { "name": "Magic Arrow" },
        { "name": "Cure Poison" },
        { "name": "Cast Light" },
        { "name": "Wall of Force" },
    ],
    [
        { "name": "Party feast" },        
        { "name": "Full Healing" },
        { "name": "Remember Location" },
        { "name": "Return to Location" },
        { "name": "Reveal Secrets" },
    ],
    [
        { "name": "Remove Curse" },        
        { "name": "Heal All" },
        { "name": "Protect All" },
        { "name": "Summon Monster" },
        { "name": "Telekinesis" },
        { "name": "View Map" },
    ],
    [
        { "name": "Fireball" },
        { "name": "Command Monster" },
        { "name": "Free from Charm" },
        { "name": "Bless Party" },
    ],
    [
        { "name": "Petrification" },
        { "name": "Cure Paralysis" },
        { "name": "Summon Demon" },
        { "name": "Lightning Strike" },
        { "name": "Invisibility" },
    ],
    [
        { "name": "Resurrection" },
        { "name": "Earthquake" },
        { "name": "Cure All Ailments" },
    ],
];
SPELLS_BY_NAME := {};

def initMagic() {
    SPELLS_BY_NAME := array_reduce(SPELLS, {}, (d, level) => { array_foreach(level, (i, s) => { d[s.name] := s; }); return d; });
}
