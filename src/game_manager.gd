extends Control

var window_active: bool = false

var TRAIN_CARD = preload("res://src/train_wagon.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	print(randi())
	Global.gm = self
	
	close_window()

	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$DebugLabel.set_text(
		"Phase: " + str(Global.round_phase) + \
		"\nactive: " + str(Global.active_player) +\
		"\nfirst: " + str(Global.first_player) +\
		"\nsecond: " + str(Global.second_player) +\
		"\nactions: " + str(Global.action_points) +\
		"\npositions: " + str(Global.player_position)
	)

func new_game():
	randomize()
	
	# Train cards
	Global.train_deck = Data.train_deck.duplicate()
	Global.train_deck.shuffle()
	Global.is_engine_found = false
	train_init()
	
	# Copy modifier decks
	Global.modifier_deck = [
		Data.modifier_deck[Global.game_difficulty].duplicate,
		Data.modifier_deck[Global.game_difficulty].duplicate,
	]
	
	hero_init()
	
	round_phase_next()
	addlog("New game has started..")


func hero_init():
	$CharSheetP1.set_hero(0)
	$CharSheetP2.set_hero(1)
	
	


func round_phase_next():
	# increase turn
	Global.round_phase += 1
	if Global.round_phase > Types.RoundPhaseDetail.CheckEndGame:
		Global.round_phase = Types.RoundPhaseDetail.PlayerSelect
	
	
	match Global.round_phase:
		Types.RoundPhaseDetail.PlayerSelect:
			$PhaseDisplay/Label.set_text("Player Action Phase")
			display_window(Types.WindowType.PlayerSelect)
		Types.RoundPhaseDetail.FirstPlayerAction:
			addlog("Player" + str(Global.active_player) + "'s turn...")
		Types.RoundPhaseDetail.SecondPlayerAction:
			addlog("Player" + str(Global.active_player) + "'s turn...")
		Types.RoundPhaseDetail.EncounterMove:
			$PhaseDisplay/Label.set_text("Enemy Action Phase")
			addlog("Moving encounters")
			pass
		Types.RoundPhaseDetail.EncounterFirstPlayer:
			addlog("Encounter FirstPlayer")
			pass
		Types.RoundPhaseDetail.EncounterSecondPlayer:
			addlog("Encounter SecondPlayer")
			pass
		Types.RoundPhaseDetail.ResupplyFirstPlayer:
			$PhaseDisplay/Label.set_text("Resupply Phase")
			$CharSheetP1.set_ap(3)
			addlog("Resupply FirstPlayer")
			pass
		Types.RoundPhaseDetail.ResupplySecondPlayer:
			$CharSheetP2.set_ap(3)
			addlog("Resupply SecondPlayer")
			pass
		Types.RoundPhaseDetail.DiscardFirstPlayer:
			addlog("Discard  FirstPlayer")
			pass
		Types.RoundPhaseDetail.DiscardSecondPlayer:
			addlog("Discard SecondPlayer")
			pass
		Types.RoundPhaseDetail.CheckEndGame:
			addlog("Check end game condition")
			pass
		_:
			printerr("Undefined round phase")

func spend_action(action: Types.ActionType, payload = null):
	# Only callable in player phase
	if Global.round_phase != Types.RoundPhaseDetail.FirstPlayerAction and Global.round_phase != Types.RoundPhaseDetail.SecondPlayerAction:
		return

	# All action points spend
	if Global.action_points == 0:
		display_window(Types.WindowType.NoActions)
		return

	# Do stuff
	var retVal = true
	match action:
		Types.ActionType.Move:
			retVal = action_move(payload)
		Types.ActionType.Search:
			retVal = action_search()



	if not retVal:
		# Action not valid
		return

	# Update
	Global.action_points -= 1
	if Global.active_player == Types.PlayerActive.Player1:
		$CharSheetP1.update()
	else:
		$CharSheetP2.update()
	return

func action_search():
	pass

func action_move(payload: String) -> bool:
	var player_position = Global.player_position[Global.active_player - 1]
	print(Global.played_train.size())
	print(player_position)
	if payload == "left":
		if player_position == 0:
			print("End of level")
			return false
		else:
			Global.player_position[Global.active_player - 1] -= 1
			train_update()
		
	elif payload == "right": 
		# Right
		if player_position == Global.played_train.size() - 1:
			if not Global.is_engine_found:
				train_reveal()
			else:
				# Engine uncovered dont move
				return false
		Global.player_position[Global.active_player - 1] += 1
		train_update()

	return true

func addlog(text: String):
	$Log.text = text + "\n" + $Log.text

func display_window(type: Types.WindowType):
	$Windows.show()
	match type:
		Types.WindowType.PlayerSelect:
			$Windows/PlayerSelect.show()
		Types.WindowType.NoActions:
			$Windows/NoActions.show()
		_:
			printerr("window not found")

func close_window():
	for child in $Windows.get_children():
		child.hide()
	$Windows.hide()
	
	

func train_init():
	var i = 0
	# Find first card that is not an engine
	for train in Global.train_deck:
		if train.type != Types.TrainCardType.Engine:
			Global.played_train.append(train.duplicate())
			break
		i += 1
	Global.train_deck.remove_at(i)
	
	# Re-Shuffle
	if i > 0:
		Global.train_deck.shuffle()

	# Clear all trains if any
	for train in $Train.get_children():
		train.queue_free()
	
	# reset player positions
	Global.player_position = [0, 0]
	
	# add first card
	var train_scene = TRAIN_CARD.instantiate()
	train_scene.setup(0)
	train_scene.add_player(1)
	train_scene.add_player(2)
	$Train.add_child(train_scene)
	
	# add unrevealed card
	train_scene = TRAIN_CARD.instantiate()
	train_scene.setup(-1)
	$Train.add_child(train_scene)

func train_update():
	# Clear all trains if any
	for train in $Train.get_children():
		train.queue_free()
	
	var i = 0
	for train in Global.played_train:
		var train_scene = TRAIN_CARD.instantiate()
		train_scene.setup(i)
		if Global.player_position[0] == i:
			train_scene.add_player(1)
		if Global.player_position[1] == i:
			train_scene.add_player(2)
		$Train.add_child(train_scene)
		i += 1
	
	if not Global.is_engine_found:
		var train_scene = TRAIN_CARD.instantiate()
		train_scene.setup(-1)
		$Train.add_child(train_scene)

func train_reveal():
	var card = Global.train_deck.pop_front()
	Global.played_train.append(card)
	
	if card.type == Types.TrainCardType.Engine:
		print("engine")
		Global.is_engine_found = true
	
	
func _on_p_1_button_up():
	Global.first_player = Types.PlayerActive.Player1
	Global.second_player = Types.PlayerActive.Player2
	Global.active_player = Global.first_player
	close_window()
	round_phase_next()


func _on_p_2_button_up():
	Global.first_player = Types.PlayerActive.Player2
	Global.second_player = Types.PlayerActive.Player1
	Global.active_player = Global.first_player
	close_window()
	round_phase_next()


func _on_move_left_button_up():
	spend_action(Types.ActionType.Move, "left")


func _on_move_right_button_up():
	spend_action(Types.ActionType.Move, "right")


func _on_end_turn_button_up():
	addlog("Round end for Player" + str(Global.active_player))
	
	if Global.active_player == Global.first_player:
		Global.active_player = Global.second_player
	Global.action_points = 3
	
	round_phase_next()
	close_window()


func _on_no_actions_end_turn_button_up():
	_on_end_turn_button_up()


func _on_debug_next_button_up():
	round_phase_next()


func _on_search_button_up():
	spend_action(Types.ActionType.Search)


func _on_debug_modifier_p_2_button_up():
	pass # Replace with function body.


func _on_debug_modifier_p_1_button_up():
	pass # Replace with function body.
