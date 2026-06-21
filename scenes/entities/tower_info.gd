extends Node
class_name TowerInfo

enum TowerType {
	LOW,
	MID,
	HIGH,
}


static var stats := {
	TowerType.LOW : {
		"name": "Low Tier",
		"damage": 1.0,
		"attack_cooldown": 0.5,
		"bullet_speed": 10.,
		"range": 200.0,
		"upgrade_price": 700,
		"animation": "low",
		"offset": Vector2(27, 146),
	},
	TowerType.MID : {
		"name": "Mid Tier",
		"damage": 1.5,
		"attack_cooldown": 0.3,
		"bullet_speed": 15.,
		"range": 250.0,
		"upgrade_price": 2500,
		"animation": "mid",
		"offset": Vector2(149, 146),
	},
	TowerType.HIGH : {
		"name": "High Tier",
		"damage": 2.0,
		"attack_cooldown": 0.2,
		"bullet_speed": 20.,
		"range": 400.0,
		"upgrade_price": 6000,
		"animation": "high",
		"offset": Vector2(-90, 136),
	}
}

static func get_level_stats(type:TowerType, level:int) -> Dictionary:
	level = clampi(level, 0, 1000000000)
	return {
		"name": stats[type]["name"],
		"damage": stats[type]["damage"] *\
			exp(level * .3),
		"attack_cooldown": stats[type]["attack_cooldown"] /\
			exp(level * .3),
		"bullet_speed": stats[type]["bullet_speed"] *\
			exp(level * .3),
		"range": stats[type]["range"] *\
			exp(level * .3),
		"upgrade_price": stats[type]["upgrade_price"] *\
			exp(level * .3),
		"animation": stats[type]["animation"],
		"offset": stats[type]["offset"],
	}
