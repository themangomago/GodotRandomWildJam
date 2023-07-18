extends Control

var card_type: Types.CardType = Types.CardType.Player
var card_owner: Types.CardOwner = Types.CardOwner.Everyone
var id: int = -1

var PLAYER_CARDS = preload("res://assets/cards/player_cards.png")
var TRAIN_CARDS = preload("res://assets/cards/train_cards.png")
var ENCOUNTER_CARDS = preload("res://assets/cards/encounter_cards.png")


signal play_card(id, linked)

# Called when the node enters the scene tree for the first time.
func setup(_card_type: Types.CardType, _card_owner: Types.CardOwner, _id: int, alternative_popup: bool = false):
	$CardZoom.hide()
	card_type = _card_type
	card_owner = _card_owner
	id = _id
	
	match _card_type:
		Types.CardType.Train:
			set_cards(TRAIN_CARDS, Data.train_cards.size() + 1,  id + 1)
		Types.CardType.Player:
			set_cards(PLAYER_CARDS, Data.player_cards.size() + 1,  id + 1)
			
			# Show costs
			if id >= 0:
				var player_card = Data.player_cards[id]
				if player_card.has("costs"):
					$Card/Costs.frame = player_card.costs
					$CardZoom/Costs.frame = player_card.costs
					$Card/Costs.show()
					$CardZoom/Costs.show()
				else:
					$Card/Costs.hide()
					$CardZoom/Costs.hide()
				
				$Card/Title.set_text(player_card.name)
				$CardZoom/Title.set_text(player_card.name)
		Types.CardType.Encounter:
			set_cards(ENCOUNTER_CARDS, Data.encounter_cards.size() + 1,  id + 1)

	if alternative_popup:
		$CardZoom.position = Vector2(32,-32)
	else:
		$CardZoom.position = Vector2(32,48)


func set_cards(texture: Texture2D, frames: int, frame: int):
	$Card/Card.texture = texture
	$Card/Card.hframes = frames
	$Card/Card.frame = frame
	$CardZoom/CardZoom.texture = texture
	$CardZoom/CardZoom.hframes = frames
	$CardZoom/CardZoom.frame = frame
	if frame != 0:
		$Card/Title.show()
		$CardZoom/Title.show()
	else:
		$Card/Title.hide()
		$CardZoom/Title.hide()

func _on_mouse_entered():
	if id >= 0:
		$Card.hide()
		$CardZoom.show()


func _on_mouse_exited():
	if id >= 0:
		$Card.show()
		$CardZoom.hide()


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("play_card", id, self)
