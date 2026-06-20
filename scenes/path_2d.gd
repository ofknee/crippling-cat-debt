extends Path2D

@export var enemy_scene: PackedScene
@export var spawn_chance := 0.01



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func spawn_enemy() -> void:
	var inst: Enemy = enemy_scene.instantiate()
	add_child(inst)

	inst.path = self
	inst.progression = 0.0
	
	
func follow_path() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if randf() < spawn_chance:
		spawn_enemy()
