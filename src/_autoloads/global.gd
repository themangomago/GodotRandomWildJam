
extends Node

var gm: Node = null

var first_player: Types.PlayerActive = Types.PlayerActive.None
var second_player: Types.PlayerActive = Types.PlayerActive.None
var active_player: Types.PlayerActive = Types.PlayerActive.None
var action_points: int = 3

var round_phase: Types.RoundPhaseDetail = Types.RoundPhaseDetail.NewGame
var is_engine_found: bool = false

# Decks
var train_deck = []
var modifier_deck = [
	[],
	[]
]
var player_decks = [
	[],
	[]
]


# Played area
var played_train = []
var played_assets = [
	[-1, -1, -1],
	[-1, -1, -1],
]

var played_skills_active = []

var discarded_cards = [ # 
	[],
	[]
]
var played_encounters = [
	[],
	[]
]


# Player data
var player_heroes = [0, 2]
var player_position = [0, 0]
var player_treasures = [3, 3]

var skill_test_required = 0
var skill_test_type = Types.ActionType.Search


# Game data
var game_difficulty = 1




var train = [
	0,
	-1
]


