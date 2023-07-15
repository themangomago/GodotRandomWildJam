extends Node

# Cards
enum CardType {
  Player,
  Train,
  Encounter,
}

enum PlayerCardType {
  Asset,
  Skill,
  Weakness,
}

enum EncounterCardType {
  Enemy,
  Treachery,
}

enum TrainCardType {
  Engine,
  Coal,
  Oil,
  Dining,
  Cargo,
  Passenger,
  Caboose,
}


# Game Play
enum RoundPhase {
  Action,
  Encounter,
  Resupply,
}

enum ActionType {
  Move,
  Attack,
  Search,
  Evade,
  PlayCard,
}

enum RoundPhaseDetail {
  NewGame = -1,
  PlayerSelect = 0,
  FirstPlayerAction = 1,
  SecondPlayerAction = 2,
  EncounterMove = 3,
  EncounterFirstPlayer = 4,
  EncounterSecondPlayer = 5,
  ResupplyFirstPlayer = 6,
  ResupplySecondPlayer = 7,
  DiscardFirstPlayer = 8,
  DiscardSecondPlayer = 9,
  CheckEndGame = 10,
}

enum CardOwner {
  Everyone,
  Player1,
  Player2,
}

enum PlayerActive {
  None,
  Player1,
  Player2,
}

enum WindowType {
  PlayerSelect,
  NoActions,
}