extends TextureRect


@export var deck_type: Types.CardType = Types.CardType.Player
@export var deck_owner: Types.CardOwner = Types.CardOwner.Everyone
@export var starts_empty: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	match deck_type:
		Types.CardType.Player:
			$Card.frame = 2
		Types.CardType.Train:
			$Card.frame = 3
		Types.CardType.Encounter:
			$Card.frame = 4
			
	if starts_empty:
		$Card.frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("card_click")
			print(deck_owner)
			print(deck_type)
