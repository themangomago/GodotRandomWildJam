# GodotRandomWildJam


TODOs:

- [x] Add player cards
- [x] Add decks for selected players
- [x] Add enemy/treachery cards

Thuesday:
- [ ] Action: Play card mechanism

  
Wednesday:
- [ ] Action: Evade/Attack mechanism
- [ ] Draw encounter mechanism
Thursday:
- [ ] Move enemy mechanism
- [ ] Engage enemy mechanism
- [ ] Resupply mechanism (draw/discard)

- [ ] All hero decks


Round Phase Detail:


1. Player Action Phase:
  1.1 Choose starting player
  1.2 Select up to 3 actions:
    1.2.1 Move
    1.2.2 Attack
    1.2.3 Search
    1.2.4 Evade
    1.2.5 Play a card from hand
  1.3 Second players turn
1. Enemy Action Phase:
  2.1 Move enemy, if enemy has hunter trait
  2.2 Engaged enemeies attack, if able
1. Resupply
  3.1 Get one gold
  3.2 Draw 1 card
  3.3 Discard down to 5 cards
1. Draw encounter card
2. Add resilience; check end game


Player Stats:

Health: How much damage can be handled before death
Resilience: How much stress can be handled before death
Attack: Damage enemies
Dodge: Dodge attacks
Willpower: Stress challenges
Intelligence: Search for goods


Heroes:

| Name            | Type     | Hp  | Res | att | dodge | will | int |
| --------------- | -------- | --- | --- | --- | ----- | ---- | --- |
| Angel Eyes      | Fighter  | 8   | 7   | 4   | 1     | 3    | 2   |
| Liberty Valance | Fighter  | 7   | 8   | 3   | 2     | 2    | 3   |
| El Indio        | Gatherer | 6   | 9   | 2   | 3     | 2    | 4   |
| Calvera         | Gatherer | 6   | 8   | 2   | 4     | 2    | 5   |
| Jack Wilson     | Support  | 4   | 10  | 0   | 3     | 5    | 3   |
| Herod           | Support  | 5   | 9   | 1   | 4     | 4    | 3   |

