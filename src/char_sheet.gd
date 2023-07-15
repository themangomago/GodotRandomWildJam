extends Panel


func update():
	$APs.set_text("APs: " + str(Global.action_points) + "/3")

func set_ap(ap):
	$APs.set_text("APs: " + str(ap) + "/3")

func set_hero(id):
	var hero = Data.heroes[id]
	
	$Name.set_text(hero.name)
	$hp.set_text(str(hero.stats.health))
	$res.set_text(str(hero.stats.resilience))
	$a.set_text(str(hero.stats.attack))
	$d.set_text(str(hero.stats.doge))
	$w.set_text(str(hero.stats.willpower))
	$i.set_text(str(hero.stats.intelligence))
	
