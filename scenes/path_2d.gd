extends Path2D

@export var enemy_scene: PackedScene



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func spawn_enemy(enemy_type: String = "fly") -> void:
	var inst: Enemy = enemy_scene.instantiate()
	inst.type = enemy_type
	inst.path = self
	inst.progression = 0.0
	inst.scale *= randf_range(0.7,1.3)
	inst.offset += randf_range(-20.0,20.0)
	add_child(inst)
	
	
	
func follow_path() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if randf() < 0.05:
		spawn_enemy()
	elif randf() < 0.01:
		spawn_enemy("mosquito")
