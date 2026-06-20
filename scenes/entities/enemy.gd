extends Node2D
class_name Enemy

@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	var fly = EnemyType.new()
	
	var mosquito = EnemyType.new()


var stats := {
	
}

var speed := 80.0
var path: Path2D
var progression := 0.0

func _process(delta):
	if path == null:
		return

	progression += speed * delta
	global_position = path.curve.sample_baked(progression)
	
	if progression >= path.curve.get_baked_length():
		queue_free()

#func damage(amount:float) -> void:
	#var atk = Attack.new()
	#atk.damage = amount
	#health_component.damage(atk)
