extends Node2D
class_name Enemy

@onready var health_component: HealthComponent = $HealthComponent
@onready var INFO = EnemyInfo.stats

@export var type := "fly"
@export var offset := 0.0


var speed := 500.0
var path: Path2D
var progression := 0.0


func _ready() -> void:
	set_type()
	print(type)
	
func set_type() -> void:
	health_component.max_health = INFO[type]["health"]
	health_component.health = health_component.max_health
	$Anim.play(type)


func _process(delta):
	if path == null:
		return

	progression += speed * delta
	global_position = path.curve.sample_baked(progression) + Vector2(0, offset)
	
	
	if progression >= path.curve.get_baked_length():
		queue_free()
		
## func do damaage
#    cat sanity -= INFO[type]["strength"]
		
	
func damage(amount:float) -> void: 
	var atk = Attack.new()
	atk.damage = amount
	health_component.damage(atk)
