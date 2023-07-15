extends Control

var deck_type: Types.CardType = Types.CardType.Player
var deck_owner: Types.CardOwner = Types.CardOwner.Everyone
var id: int = -1


# Called when the node enters the scene tree for the first time.
func setup(_deck_type: Types.CardType, _deck_owner: Types.CardOwner, _id: int):
	deck_type = _deck_type
	deck_owner = _deck_owner
	id = _id
	$Card.frame = id 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
