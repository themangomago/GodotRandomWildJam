extends TextureRect


@export var deck_type: Types.CardType = Types.CardType.Player
@export var deck_owner: Types.CardOwner = Types.CardOwner.Everyone
@export var starts_empty: bool = false # empty stack
@export var is_hidden: bool = true # deck is facing backside
@export var id: int = -1

signal draw_card()

func _ready():
	$Card.setup(deck_type, deck_owner, id)
	
	if starts_empty:
		$Card.hide()
	else:
		$Card.show()



func _on_card_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("draw_card")

