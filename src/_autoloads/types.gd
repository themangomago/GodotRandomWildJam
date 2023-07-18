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

enum AssetLocationType {
  Head = 0,
  Hand = 1,
  Body = 2
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
  DrawEnemyCard = 10,
  CheckEndGame = 11,
}

enum CardOwner {
  Everyone = -1,
  Player1 = 0,
  Player2 = 1,
}

enum PlayerActive {
  None = -1,
  Player1 = 0,
  Player2 = 1,
}

enum WindowType {
  PlayerSelect,
  NoActions,
}

enum SkillType {
  Attack,
  Dodge,
  Willpower,
  Intelligence
}

