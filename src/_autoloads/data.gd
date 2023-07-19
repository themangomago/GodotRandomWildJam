extends Node


var player_cards = [
	# Weaknesses (deck: 2 random) # 6
	{"type": Types.PlayerCardType.Weakness, "name": "Panik!", "desc": "", "effects": [{"e": "drop_cards", "a": -1}]},
	{"type": Types.PlayerCardType.Weakness, "name": "Paranoia", "desc": "", "effects": [{"e": "gold", "a": -99}]},
	{"type": Types.PlayerCardType.Weakness, "name": "Scatterbrained", "desc": "", "effects": [{"e": "scatterbrained"}]},
	{"type": Types.PlayerCardType.Weakness, "name": "Rattlers Bite", "desc": "", "effects": [{"e": "rattlersbite"}]},
	{"type": Types.PlayerCardType.Weakness, "name": "Traitor", "desc": "", "effects": [{"e": "threat_area"}]},
	{"type": Types.PlayerCardType.Weakness, "name": "Bad Day", "desc": "", "effects": [{"e": "threat_area"}]},
	# Skills #12
	{"type": Types.PlayerCardType.Skill, "name": "First Aid", "desc": "Heals 2", "effects": [{"e": "heal", "a": 2}], "costs": 0},
	{"type": Types.PlayerCardType.Skill, "name": "Lucky", "desc": "", "effects": [{"e": "skill_test", "a": 1}], "costs": 0},
	{"type": Types.PlayerCardType.Skill, "name": "Sheriffs Badge", "desc": "", "effects": [{"e": "resilience", "a": -1}], "costs": 2},
	{"type": Types.PlayerCardType.Skill, "name": "Fortified Homestead", "desc": "", "effects": [{"e": "resilience", "a": -1}], "costs": 2},
	{"type": Types.PlayerCardType.Skill, "name": "Gold Rush", "desc": "", "effects": [{"e": "intelligence", "a": 2}], "costs": 2},
	{"type": Types.PlayerCardType.Skill, "name": "Dynamite", "desc": "", "effects": [{"e": "damage_all", "a": 3}], "costs": 4},
	{"type": Types.PlayerCardType.Skill, "name": "Deadeye", "desc": "", "effects": [{"e": "attack", "a": 2}], "costs": 2},
	{"type": Types.PlayerCardType.Skill, "name": "Lasso", "desc": "", "effects": [{"e": "dodge", "a": 2}], "costs": 2},
	{"type": Types.PlayerCardType.Skill, "name": "Guts", "desc": "", "effects": [{"e": "skill_test", "a": 1}], "costs": 1},
	{"type": Types.PlayerCardType.Skill, "name": "True Grit", "desc": "", "effects": [{"e": "skill_test", "a": 2}], "costs": 2},
	{"type": Types.PlayerCardType.Skill, "name": "Snake Oil", "desc": "", "effects": [{"e": "skill_test", "a": 2}, {"e": "heal", "a": -2}], "costs": 1},
	{"type": Types.PlayerCardType.Skill, "name": "Saddlebags", "desc": "", "effects": [{"e": "gold", "a": 4}], "costs": 1},
	# Assets #12
	{"type": Types.PlayerCardType.Asset, "name": "Lockpick", "desc": "", "effects": [{"e": "intelligence", "a": 1}], "location": Types.AssetLocationType.Hand, "costs": 2},
	{"type": Types.PlayerCardType.Asset, "name": "LeMat Revolver", "desc": "", "effects": [{"e": "attack", "a": 1}], "location": Types.AssetLocationType.Hand, "costs": 2},
	{"type": Types.PlayerCardType.Asset, "name": "Derringer", "desc": "", "effects": [{"e": "attack", "a": 2}], "location": Types.AssetLocationType.Hand, "costs": 2},
	{"type": Types.PlayerCardType.Asset, "name": "Colt", "desc": "", "effects": [{"e": "attack", "a": 2}], "location": Types.AssetLocationType.Hand, "costs": 3},
	{"type": Types.PlayerCardType.Asset, "name": "Winchester 1873", "desc": "", "effects": [{"e": "attack", "a": 2}], "location": Types.AssetLocationType.Hand, "costs": 3},
	{"type": Types.PlayerCardType.Asset, "name": "Knife", "desc": "", "effects": [{"e": "attack", "a": 1}], "location": Types.AssetLocationType.Hand, "costs": 1},
	{"type": Types.PlayerCardType.Asset, "name": "Steton Hat", "desc": "", "effects": [{"e": "intelligence", "a": 1}], "location": Types.AssetLocationType.Head, "costs": 1},
	{"type": Types.PlayerCardType.Asset, "name": "Bandana", "desc": "", "effects": [{"e": "dodge", "a": 1}], "location": Types.AssetLocationType.Head, "costs": 1},
	{"type": Types.PlayerCardType.Asset, "name": "Derby Hat", "desc": "", "effects": [{"e": "willpower", "a": 1}], "location": Types.AssetLocationType.Head, "costs": 1},
	{"type": Types.PlayerCardType.Asset, "name": "Buckskin Jacket", "desc": "", "effects": [{"e": "heal", "a": 2}], "location": Types.AssetLocationType.Head, "costs": 1},
	{"type": Types.PlayerCardType.Asset, "name": "Bullet Proof Vest", "desc": "", "effects": [{"e": "heal", "a": 2}, {"e": "resilience", "a": -1}], "location": Types.AssetLocationType.Head, "costs": 2},
	{"type": Types.PlayerCardType.Asset, "name": "Spurs", "desc": "", "effects": [{"e": "dodge", "a": 1}], "location": Types.AssetLocationType.Head, "costs": 1},
]

var hero_decks = [
	[-1, -1, 6, 6, 7, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 21, 23, 24, 27, 28], #angel
	[-1, -1, 6, 6, 7, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 22, 23, 25, 27, 29], #liberty
	[-1, -1, 6, 6, 7, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 23, 26, 28, 29], #indio
]

var encounter_cards = [
	# Treachery
	{"type": Types.EncounterCardType.Treachery, "name": "Sudden Fog", "desc": "", "effects": [{"e": "search", "a": 1}]},
	{"type": Types.EncounterCardType.Treachery, "name": "Sudden Brake", "desc": "", "effects": [{"e": "dodge_check", "a": 3, "s": {}, "f": {"e": "health", "a": -2}}]},
	{"type": Types.EncounterCardType.Treachery, "name": "Explosive Cargo", "desc": "", "effects": [{"e": "intelligence_check", "a": 3, "s": {}, "f": {"e": "health", "a": -2}}]},
	{"type": Types.EncounterCardType.Treachery, "name": "Jammed Door", "desc": "", "effects": [{"e": "attack_check", "a": 3, "s": {}, "f": {"e": "health", "a": -2}}]},
	{"type": Types.EncounterCardType.Treachery, "name": "Derailment", "desc": "", "effects": [{"e": "willpower_check", "a": 3, "s": {}, "f": {"e": "resilience", "a": -2}}]},
	{"type": Types.EncounterCardType.Treachery, "name": "Train Sickness", "desc": "", "effects": [{"e": "dodge_check", "a": 3, "s": {}, "f": {"e": "resilience", "a": -2}}]},
	{"type": Types.EncounterCardType.Treachery, "name": "Cursed Relic", "desc": "", "effects": [{"e": "health", "a": -1}, {"e": "resilience", "a": -1}]},
	{"type": Types.EncounterCardType.Treachery, "name": "Bribery", "desc": "Lose 2 gold or resilience -1", "effects": [{"e": "gold", "a": -2}]},
	{"type": Types.EncounterCardType.Treachery, "name": "Safe-Cracking", "desc": "", "effects": [{"e": "intelligence_check", "a": 3, "s": {"e": "gold", "a": 2}, "f": {"e": "resilience", "a": -1}}]},
	{"type": Types.EncounterCardType.Treachery, "name": "Panic in the Crowd", "desc": "", "effects": [{"e": "resilience", "a": -1}]},
	{"type": Types.EncounterCardType.Treachery, "name": "Sudden Frog", "desc": "", "effects": []},
	{"type": Types.EncounterCardType.Treachery, "name": "Dense Exhaust Fumes", "desc": "", "effects": [{"e": "search", "a": 1}]},
	# Enenemy
	{"type": Types.EncounterCardType.Enemy, "name": "Railway Guard", "desc": "", "stats": [3, 2, 2], "damage": [1, 0]},
	{"type": Types.EncounterCardType.Enemy, "name": "Crazed Traveller", "desc": "", "stats": [3, 2, 2], "damage": [1, 1]},
	{"type": Types.EncounterCardType.Enemy, "name": "Gunslinger", "desc": "", "stats": [4, 4, 3], "damage": [2, 0]},
	{"type": Types.EncounterCardType.Enemy, "name": "Marshal", "desc": "", "stats": [4, 2, 3], "damage": [2, 0]},
	{"type": Types.EncounterCardType.Enemy, "name": "Train Conductor", "desc": "", "stats": [2, 2, 2], "damage": [1, 0]},
	{"type": Types.EncounterCardType.Enemy, "name": "Guard Dog", "desc": "", "stats": [2, 1, 4], "damage": [1, 1]},
]

var encounter_deck = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,10, 11, 12,12, 13, 14, 15, 16, 17]

var train_cards = [
	{
		"type": Types.TrainCardType.Engine,
		"name": "Engine",
		"treasure": 0,
		"difficulty": 3,
		"frame": 2,
	},
	{
		"type": Types.TrainCardType.Passenger,
		"name": "Passenger1",
		"treasure": 2,
		"difficulty": 3,
		"frame": 1,
	},
	{
		"type": Types.TrainCardType.Passenger,
		"name": "Passenger2",
		"treasure": 2,
		"difficulty": 2,
		"frame": 1,
	},
	{
		"type": Types.TrainCardType.Passenger,
		"name": "Passenger3",
		"treasure": 4,
		"difficulty": 4,
		"frame": 1,
	},
	{
		"type": Types.TrainCardType.Passenger,
		"name": "Passenger3",
		"treasure": 4,
		"difficulty": 4,
		"frame": 1,
	},
	{
		"type": Types.TrainCardType.Passenger,
		"name": "Passenger3",
		"treasure": 4,
		"difficulty": 4,
		"frame": 1,
	},
	{
		"type": Types.TrainCardType.Passenger,
		"name": "Passenger3",
		"treasure": 4,
		"difficulty": 4,
		"frame": 1,
	},
	{
		"type": Types.TrainCardType.Passenger,
		"name": "Passenger3",
		"treasure": 4,
		"difficulty": 4,
		"frame": 1,
	},
	{
		"type": Types.TrainCardType.Passenger,
		"name": "Passenger3",
		"treasure": 4,
		"difficulty": 4,
		"frame": 1,
	},
]

var heroes = [
	{
		"name": "Angel Eyes",
		"stats": {
			"health": 8,
			"resilience": 7,
			"attack": 4,
			"dodge": 1,
			"willpower": 3,
			"intelligence": 2,
		}
	},
	{
		"name": "Liberty Valance",
		"stats": {
			"health": 7,
			"resilience": 8,
			"attack": 3,
			"dodge": 2,
			"willpower": 2,
			"intelligence": 3,
		},
	},
	{
			"name": "El Indio",
			"stats": {
				"health": 6,
				"resilience": 9,
				"attack": 2,
				"dodge": 3,
				"willpower": 2,
				"intelligence": 4,
			},
	}
]


var modifier_deck = [
	[2, 2, 1,  1,  1, 0,  0,  0, -1, -1, -2, -2, 99, -99], #easy
	[2, 1, 1,  0,  0, 0,  -1, -1, -1, -2, -3, -4, 99, -99], # normal
	[1, 1, 0, -1, -1, -1, -2, -2, -3, -3, -4, 99, -99, -99], # hard
]

