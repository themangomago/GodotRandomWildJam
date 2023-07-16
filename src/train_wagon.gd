extends Control


func setup(id):
	if id == -1:
		$Card.setup(Types.CardType.Train, Types.CardOwner.Everyone, 0)
	else:
		var cart = Global.played_train[id]
		$Name.set_text(str(cart.name))
		$Card.setup(Types.CardType.Train, Types.CardOwner.Everyone, cart.frame)

		var i = 0
		for gold in $Gold.get_children():
			i += 1
			if cart.treasure >= i:
				gold.show()
			else:
				gold.hide()
			
			
	

func remove_player(id):
	if id != 1:
		$players/p1.hide()
	else:
		$players/p2.hide()

func add_player(id):
	if id != 1:
		$players/p1.show()
	else:
		$players/p2.show()
