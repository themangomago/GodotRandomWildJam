extends Control

var fs = false

var id = 0

func _ready():
	display_card()

func display_card():
	#setup(_deck_type: Types.CardType, _deck_owner: Types.CardOwner, _id: int):
	$Card.setup(Types.CardType.Player, 0, id)

func _on_minus_button_up():
	id -= 1
	display_card()


func _on_plus_button_up():
	id += 1
	display_card()


func _on_debug_fullscreen_button_up():

	if fs:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fs = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fs = true

