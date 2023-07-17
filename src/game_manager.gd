extends Control

var window_active: bool = false

var TRAIN_CARD = preload("res://src/train_wagon.tscn")
var fs = false
var motion = true

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	print(randi())
	Global.gm = self
	
	close_window()
	$Notification/AnimationPlayer.play("RESET")
	$ModifierDraw/AnimationPlayer.play("RESET")

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
		Data.modifier_deck[Global.game_difficulty].duplicate(),
		Data.modifier_deck[Global.game_difficulty].duplicate(),
	]
	
	hero_init()
	
	round_phase_next()
	addlog("New game has started..")


func hero_init():
	$CharSheetP1.set_hero(0)
	$CharSheetP2.set_hero(1)
	


func skill_test(skill: Types.SkillType, target: int):
	var hero = Data.heroes[Global.player_heroes[Global.active_player]]
	var player_name = hero.name
	var skill_name: String
	var player_skill = 0
	match skill:
		Types.SkillType.Attack:
			skill_name = "Attack"
			player_skill = hero.stats.attack
		Types.SkillType.Dodge:
			skill_name = "Dodge"
			player_skill = hero.stats.dodge
		Types.SkillType.Willpower:
			skill_name = "Willpower"
			player_skill = hero.stats.willpower
		Types.SkillType.Intelligence:
			skill_name = "Intelligence"
			player_skill = hero.stats.intelligence
		_: 
			printerr("Skill not found")
	var bonus = skill_test_calc_bonus(skill)
	var marked_as_burned = skill_test_get_burned()
	Global.skill_test_required = target - player_skill - bonus - marked_as_burned
	Global.skill_test_type = Types.ActionType.Search
	$SkillCheck/Title.set_text("Skill Test ("+ player_name +")")
	$SkillCheck/Requirements.set_text(skill_name + "(" + str(target) + "): You will need to draw a " + str(Global.skill_test_required) + " or better.")
	$SkillCheck.show()

func skill_test_calc_bonus(skill: Types.SkillType):
	# ToDo: Check played cards for bonuses from player. 
	# also from another player if its dependend on the room
	return 0

func skill_test_get_burned():
	# ToDo: Get marked as burned cards
	return 0

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
		Types.ActionType.Attack:
			pass
		Types.ActionType.Evade:
			pass
		Types.ActionType.PlayCard:
			pass


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

func action_search() -> bool:
	var player_position = Global.player_position[Global.active_player - 1]
	
	# Check if searchable
	if Global.played_train.size() <= player_position:
		return false

	# Check if treasures left
	if Global.played_train[player_position].treasure == 0:
		addlog("Search: No treasures left here.")
		return false
		
	var search_difficulty = Global.played_train[player_position].difficulty - search_calc_bonus()
	skill_test(Types.SkillType.Intelligence, search_difficulty)
	return true

func search_calc_bonus():
	# TODO: search bonuses like oil lamp
	return 0

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


func draw_card_modifier(deck: int):
	var card = Global.modifier_deck[deck].pop_front()
	Global.modifier_deck[deck].append(card)
	
	match card:
		2: $ModifierDraw.frame = 1
		1: $ModifierDraw.frame = 2
		0: $ModifierDraw.frame = 3
		-1: $ModifierDraw.frame = 4
		-2: $ModifierDraw.frame = 5
		-3: $ModifierDraw.frame = 6
		-4: $ModifierDraw.frame = 7
		99: $ModifierDraw.frame = 8
		-99: $ModifierDraw.frame = 9
	$ModifierDraw/AnimationPlayer.play("popup")
	
	if Global.skill_test_required <= card:
		$Notification/Title.set_text("Skill Test Successful")
		if Global.skill_test_type == Types.ActionType.Search:
			Global.played_train[Global.player_position[Global.active_player - 1]].treasure -= 1
			Global.player_treasures[Global.player_position[Global.active_player - 1]] += 1
			if Global.active_player == Types.PlayerActive.Player1:
				$CharSheetP1.add_treasure(0)
			else:
				$CharSheetP2.add_treasure(1)
			train_update()
	else:
		$Notification/Title.set_text("Skill Test Failed")
	
	$Notification/AnimationPlayer.play("popup")
	$SkillCheck.hide()
	
	#TODO display modifier card
	
	if card == 99 or card == -99:
		addlog("Shuffling modifier deck")
		Global.modifier_deck[deck].shuffle()


func _on_debug_modifier_p_1_button_up():
	if Global.active_player != Types.PlayerActive.Player1:
		addlog("This is not your deck.")
		return
	draw_card_modifier(0)

func _on_debug_modifier_p_2_button_up():
	if Global.active_player != Types.PlayerActive.Player2:
		addlog("This is not your deck.")
		return
	draw_card_modifier(1)



func _on_debug_fs_button_up():

	if fs:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fs = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fs = true


func _on_debug_m_button_up():
	if not motion:
		$"Background/6".material.set("shader_parameter/speed", 0.05)
		$"Background/5".material.set("shader_parameter/speed", 0.1)
		$"Background/4".material.set("shader_parameter/speed", 0.2)
		$"Background/3".material.set("shader_parameter/speed", 0.3)
		$"Background/2".material.set("shader_parameter/speed", 0.4)
		$"Background/1".material.set("shader_parameter/speed", 0.5)
		motion = true
	else:
		$"Background/6".material.set("shader_parameter/speed", 0.0)
		$"Background/5".material.set("shader_parameter/speed", 0.0)
		$"Background/4".material.set("shader_parameter/speed", 0.0)
		$"Background/3".material.set("shader_parameter/speed", 0.0)
		$"Background/2".material.set("shader_parameter/speed", 0.0)
		$"Background/1".material.set("shader_parameter/speed", 0.0)
		motion = false
