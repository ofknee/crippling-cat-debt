extends Path2D

@export var enemy_scene: PackedScene
var speed := 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_yo_hand() # Replace with function body.

func spawn_enemy(enemy_type: EnemyInfoResource.EnemyType) -> void:
	var inst: Enemy = enemy_scene.instantiate() as Enemy
	inst.type = enemy_type
	inst.path = self
	inst.progression = 0.0
	inst.scale *= randf_range(1.8,2.5)
	inst.offset += randf_range(-20.0,20.0)
	inst.speed = speed
	add_child(inst)
	
func wave_yo_hand():
	while true:
		await spawn_wave()
		SignalBus.wave_finished.emit(Global.wave)
		Global.wave += 1
		speed += 67 * sqrt(Global.wave)*0.67
		await get_tree().create_timer(6.67).timeout
		
func spawn_wave() -> void:
	for i in range(6+ceil(Global.wave*1.67)):
		if randf() < 0.05:
			spawn_enemy(EnemyInfoResource.EnemyType.BLOB)
		elif randf() < 0.15:
			spawn_enemy(EnemyInfoResource.EnemyType.BEETLE)
		else:
			spawn_enemy(EnemyInfoResource.EnemyType.FLY)

		await get_tree().create_timer(100/speed).timeout

	
	
func follow_path() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass
	#if randf() < 0.05:
		#spawn_enemy()
	#elif randf() < 0.01:
		#spawn_enemy("mosquito")
