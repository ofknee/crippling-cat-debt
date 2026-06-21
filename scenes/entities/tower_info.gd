extends Node
class_name TowerInfo

enum TowerType {
	LOW,
	MID,
	HIGH,
}


static var stats := {
	
	TowerType.LOW : {
		"damage": 1.0,
		"attack_cooldown": 0.1,
		"bullet_speed": 10.,
		"range": 200.0,
		#"icon" : preload,
	},
	
	TowerType.MID : {
		"damage": 1.0,
		"attack_cooldown": 0.1,
		"bullet_speed": 10.,
		"range": 200.0,
		#"icon" : preload,
	},
	
	TowerType.HIGH : {
		"damage": 1.0,
		"attack_cooldown": 0.1,
		"bullet_speed": 10.,
		"range": 200.0,
		#"icon" : preload,
	}
	
}
