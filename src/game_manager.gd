extends Control

var window_active: bool = false

var TRAIN_CARD = preload("res://src/train_wagon.tscn")
var CARD_SCENE = preload("res://src/card.tscn")
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
		"\npositions: " + str(Global.player_position)+\
		"\nassets: " + str(Global.played_assets)+\
		"\nactive: " + str(Global.played_skills_active)
	)

func new_game():
	randomize()
	
	# Train cards
	Global.train_deck = Data.train_cards.duplicate()
	Global.train_deck.shuffle()
	Global.is_engine_found = false
	train_init()
	
	
	Global.encounter_deck = Data.encounter_deck.duplicate()
	Global.encounter_deck.shuffle()
	Global.encounter_deck.shuffle()
	
	# Copy modifier decks
	Global.modifier_deck = [
		Data.modifier_deck[Global.game_difficulty].duplicate(),
		Data.modifier_deck[Global.game_difficulty].duplicate(),
	]

	# Visual setup
	$Player1/Asset0.empty()
	$Player1/Asset1.empty()
	$Player1/Asset2.empty()
	$Player1/Discard.empty()
	$Player2/Asset0.empty()
	$Player2/Asset1.empty()
	$Player2/Asset2.empty()
	$Player2/Discard.empty()

	hero_init()
	
	round_phase_next()
	addlog("New game has started..")


func hero_init():
	
	Global.player_treasures = [3, 3]

	
	$Player1/CharSheet.setup(0, Global.player_heroes[0])
	$Player2/CharSheet.setup(1, Global.player_heroes[1])
	
	# Get player cards, add weakness, shuffle
	for i in range(2):
		Global.player_decks[i] = Data.hero_decks[Global.player_heroes[i]]
		# Add weakness
		var rand_1 = randi() % 6
		var rand_2 = randi() % 6 
		while rand_1 == rand_2: rand_2 = randi() % 6
		Global.player_decks[i][0] = rand_1
		Global.player_decks[i][1] = rand_2
		
		# Shuffle
		Global.player_decks[i].shuffle()
		Global.player_decks[i].shuffle()

	for i in range(3):
		# Deal
		player_draw_card(Types.PlayerActive.Player1, true)
		player_draw_card(Types.PlayerActive.Player2, true)


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
			$PhaseDisplay/Label.set_text("Player Action Phase: Player " + str(Global.active_player + 1))
			addlog("Player" + str(Global.active_player) + "'s turn...")
		Types.RoundPhaseDetail.SecondPlayerAction:
			$PhaseDisplay/Label.set_text("Player Action Phase: Player " + str(Global.active_player + 1))
			addlog("Player" + str(Global.active_player) + "'s turn...")

		Types.RoundPhaseDetail.EncounterFirstPlayer:
			next_player()
			addlog("Encounter FirstPlayer")
		Types.RoundPhaseDetail.EncounterSecondPlayer:
			next_player()
			addlog("Encounter SecondPlayer")
		Types.RoundPhaseDetail.ResupplyFirstPlayer:
			next_player()
			$PhaseDisplay/Label.set_text("Resupply Phase")
			Global.action_points = 3
			Global.player_treasures[0] += 1
			$CharSheetP1.update()
			addlog("Resupply FirstPlayer")
			pass
		Types.RoundPhaseDetail.ResupplySecondPlayer:
			next_player()
			Global.player_treasures[1] += 1
			$CharSheetP2.update()
			addlog("Resupply SecondPlayer")
			pass
		Types.RoundPhaseDetail.DiscardFirstPlayer:
			next_player()
			addlog("Discard FirstPlayer")
			pass
		Types.RoundPhaseDetail.DiscardSecondPlayer:
			next_player()
			addlog("Discard SecondPlayer")
			pass
		Types.RoundPhaseDetail.DrawEnemyCardFirstPlayer:
			next_player()
			addlog("Player" + str(Global.active_player) + ": Draw encounter card")
		Types.RoundPhaseDetail.DrawEnemyCardSecondPlayer:
			next_player()
			addlog("Player" + str(Global.active_player) + ": Draw encounter card")
		Types.RoundPhaseDetail.CheckEndGame:
			addlog("Check end game condition")
			pass
		_:
			printerr("Undefined round phase")

func spend_action(action: Types.ActionType, payload = null):
	print("spend_action")
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
			retVal = player_play_card(payload.id, payload.link)
		_:
			printerr("unknown action")


	if not retVal:
		# Action not valid
		return

	# Update
	Global.action_points -= 1
	get_node("Player"+str(Global.active_player + 1)+"/CharSheet").update()
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

func next_player():
	if Global.active_player == Global.first_player:
		Global.active_player = Global.second_player
	else:
		Global.active_player = Global.first_player

func _on_end_turn_button_up():
	addlog("Round end for Player" + str(Global.active_player))
	
	next_player()
	Global.action_points = 3
	Global.played_skills_active = []
	
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
				$CharSheetP1.update_treasure()
			else:
				$CharSheetP2.update_treasure()
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


func player_draw_card(player: Types.PlayerActive, skip_weakness = false):
	var hand = get_node("Player" + str(player + 1) + "/Hand")
	
	var card = Global.player_decks[player].pop_front()
	
	# Skip weaknesses on initial deal
	if skip_weakness:
		while card < 6:
			Global.player_decks[player].append(card)
			card = Global.player_decks[player].pop_front()
	else:
		if card < 6:
			printerr("handle weakness")
			#TODO: handle weakness
	
	var card_scene = CARD_SCENE.instantiate()
	card_scene.setup(Types.CardType.Player, player, card, true)
	card_scene.connect("play_card", player_play_card_check)
	hand.add_child(card_scene)

func player_play_card(id: int, link: Object) -> bool:
	print("player_play_card")
	# check resource cost
	if Global.player_treasures[Global.active_player] < Data.player_cards[id].costs:
		addlog("Cant afford to play this card")
		return false
	else:
		# Remove costs
		Global.player_treasures[Global.active_player] -= Data.player_cards[id].costs
	
	# Assets Cards
	if Data.player_cards[id].type == Types.PlayerCardType.Asset:
		# check if is asset and asset space is free -> remove old asset
		if Global.played_assets[Global.active_player][Data.player_cards[id].location] > -1:
			# Already equiped item
			# Put on discard stack
			var old_card_id = Global.played_assets[Global.active_player][Data.player_cards[id].location]
			Global.discarded_cards[Global.active_player].append(old_card_id)
			get_node("Player" + str(Global.active_player + 1) + "/Discard").setup(Types.CardType.Player, Global.active_player, old_card_id)
		
		# Add to played assets
		Global.played_assets[Global.active_player][Data.player_cards[id].location] = id
		# Display card
		var card: Object = get_node("Player" + str(Global.active_player + 1) + "/Asset" + str(Data.player_cards[id].location))
		card.setup(Types.CardType.Player, Global.active_player, id)
		# Remove card from hand
		link.queue_free()
		return true

	# Skill Cards
	elif Data.player_cards[id].type == Types.PlayerCardType.Skill:
		# Add to active skills
		Global.played_skills_active.append(id)
		# Add card to discard pile
		get_node("Player" + str(Global.active_player + 1) + "/Discard").setup(Types.CardType.Player, Global.active_player, id)
		# Remove card from hand
		link.queue_free()
		return true
	
	return false

func update_discard_stack():
	#TODO
	pass

func player_play_card_check(id: int, link: Object):
	print("player_play_card_check")
	if Global.active_player == link.card_owner:
		print("is owner")
		
		# Handle play card in round
		if Global.round_phase == Types.RoundPhaseDetail.FirstPlayerAction \
			or Global.round_phase == Types.RoundPhaseDetail.SecondPlayerAction:
			print("roundphase correct")
			spend_action(Types.ActionType.PlayCard, {"id": id, "link": link})
				
			# checks
			print(id)
			print(link)
	else:
		addlog("This is not your card")

func player_draw_card_checks(owner: Types.PlayerActive):
	if Global.active_player == owner:
		# TODO: check if player is allowed to draw
		if Global.round_phase == Types.RoundPhaseDetail.ResupplyFirstPlayer \
			or Global.round_phase == Types.RoundPhaseDetail.ResupplySecondPlayer:
			player_draw_card(owner)
		else:
			addlog("You cannot draw a card now")
	else:
		addlog("This is not your deck")


func _on_player_1_pile_draw_card():
	player_draw_card_checks(Types.PlayerActive.Player1)


func _on_player_2_pile_draw_card():
	player_draw_card_checks(Types.PlayerActive.Player2)


func _on_encounter_pile_draw_card():
	if Global.round_phase == Types.RoundPhaseDetail.DrawEnemyCardFirstPlayer \
		or Global.round_phase == Types.RoundPhaseDetail.DrawEnemyCardSecondPlayer:
			pass
	else:
		addlog("You cannot draw a card now")

