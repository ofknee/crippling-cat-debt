extends Resource
class_name EnemyInfoResource

enum EnemyType {
	FLY,
	BEETLE,
	BLOB,
}

@export var type: EnemyType = EnemyType.FLY
@export var name := "Fly"
@export var strength := 5.0
@export var health := 2.0
@export var speed := 1.0
@export var drop_price := 200
@export var offset := Vector2i.ZERO
