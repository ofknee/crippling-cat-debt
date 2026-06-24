extends Node

const E = EnemyInfoResource.EnemyType
const T = TowerInfoResource.TowerType

var enemies = {
	E.FLY : preload("res://assets/resources/e_fly.tres"),
	E.BEETLE : preload("res://assets/resources/e_beetle.tres"),
	E.BLOB : preload("res://assets/resources/e_blob.tres"),
}
var towers = {
	T.LOW : preload("res://assets/resources/t_low.tres"),
	T.MID : preload("res://assets/resources/t_mid.tres"),
	T.HIGH : preload("res://assets/resources/t_high.tres"),
}

func get_enemy(type:E) -> EnemyInfoResource:
	var out = enemies.get(type)
	if out:
		return out
	else:
		push_warning("Enemy Type not found, returning default")
		return enemies.get(E.FLY)
func get_tower(type:T) -> TowerInfoResource:
	var out = towers.get(type)
	if out:
		return out
	else:
		push_warning("Tower Type not found, returning default")
		return towers.get(T.LOW)

## Function that gets the stats of a given tower at the given level
func get_leveled_tower(type:T, level:int) -> TowerInfoResource:
	level = clampi(level, 0, 1000000000)
	var stats = EntityDatabase.get_tower(type)
	var t = TowerInfoResource.new()
	t.name = stats.name
	t.damage = stats.damage *\
		exp(level * .15)
	t.attack_cooldown = stats.attack_cooldown *\
		exp(level * .05)
	t.bullet_speed = stats.bullet_speed *\
		exp(level * .15)
	t.range = stats.range *\
		exp(level * .10)
	t.upgrade_price = stats.upgrade_price *\
		exp(level * .15)
	t.animation = stats.animation
	t.offset = stats.offset
	return t

## Function that gets the stats of a given enemy at the given level
func get_leveled_enemy(type:E, level:int) -> EnemyInfoResource:
	level = clampi(level, 0, 1000000000)
	var stats = EntityDatabase.get_enemy(type)
	var e = EnemyInfoResource.new()
	e.name = stats.name
	e.damage = stats.damage *\
		exp(level * .15)
	e.attack_cooldown = stats.attack_cooldown *\
		exp(level * .05)
	e.bullet_speed = stats.bullet_speed *\
		exp(level * .15)
	e.range = stats.range *\
		exp(level * .10)
	e.upgrade_price = stats.upgrade_price *\
		exp(level * .15)
	e.animation = stats.animation
	e.offset = stats.offset
	return e
