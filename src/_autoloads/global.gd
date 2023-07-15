
extends Node

var gm: Node = null

var first_player: Types.PlayerActive = Types.PlayerActive.None
var second_player: Types.PlayerActive = Types.PlayerActive.None
var active_player: Types.PlayerActive = Types.PlayerActive.None
var action_points: int = 3

var round_phase: Types.RoundPhaseDetail = Types.RoundPhaseDetail.NewGame
var is_engine_found: bool = false

var train_deck = []
var played_train = []

var game_difficulty = 1

var modifier_deck = [
	[],
	[]
]

var train = [
	0,
	-1
]

var player_position = [0, 0]
var player_heroes = [0, 2]
