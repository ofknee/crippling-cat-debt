extends Resource
class_name TowerInfoResource

enum TowerType {
	LOW,
	MID,
	HIGH,
}


@export var name := "Low Tier"
@export var type := TowerType.LOW
@export var attack_cooldown := 0.5
@export var bullet_speed := 10.0
@export var range := 200.0
@export var upgrade_proce := 1000
@export var animation := "low"
@export var offset := Vector2i(27, 146)
