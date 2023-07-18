extends Panel

var player_id = -1

func update():
	$APs.set_text("APs: " + str(Global.action_points) + "/3")
	$g.set_text(str(Global.player_treasures[player_id]))

func set_ap(ap):
	$APs.set_text("APs: " + str(ap) + "/3")

func setup(player: int, hero_id: int):
	var hero = Data.heroes[hero_id]
	player_id = player
	$Name.set_text(hero.name)
	$hp.set_text(str(hero.stats.health))
	$res.set_text(str(hero.stats.resilience))
	$a.set_text(str(hero.stats.attack))
	$d.set_text(str(hero.stats.dodge))
	$w.set_text(str(hero.stats.willpower))
	$i.set_text(str(hero.stats.intelligence))
	
	update_treasure()


func update_treasure():
	print("not needed")
