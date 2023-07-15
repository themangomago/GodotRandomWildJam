extends Node


var train_deck = [
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
			"doge": 1,
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
			"doge": 2,
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
				"doge": 3,
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
