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
		#"icon" : preload,
	},
	
	TowerType.MID : {
		"name": "Mid Tier",
		"damage": 1.0,
		"attack_cooldown": 0.1,
		"bullet_speed": 15.,
		"range": 200.0,
		#"icon" : preload,
	},
	
	TowerType.HIGH : {
		"name": "High Tier",
		"damage": 1.0,
		"attack_cooldown": 0.1,
		"bullet_speed": 10.,
		"range": 200.0,
		#"icon" : preload,
	}
	
}
