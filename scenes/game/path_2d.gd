
extends Path2D

@export var enemy_scene: PackedScene
var speed := 70.0
var wave_spawning_in_progress : bool = false
var skip_wait : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().get_tree().create_timer(2.67)
	wave_yo_hand() # Replace with function body. # spawn a wave
	SignalBus.skip_wave.connect(skip_between_waves)
	
#func _process(delta: float) -> void:
	#while true:
		#if wave_spawning_in_progress == false:
			#await wave_yo_hand()

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
	
	if wave_spawning_in_progress:
		return
	wave_spawning_in_progress = true
	
	
	while true:
		await spawn_wave()
		SignalBus.wave_finished.emit(Global.wave)
		Global.wave += 1
		speed += 67 * sqrt(Global.wave)*0.67
		print("wave",Global.wave)
		skip_wait = false
		var timer := get_tree().create_timer(6.67)
		while timer.time_left > 0.0 and !skip_wait:
			await get_tree().process_frame
			
func spawn_wave() -> void:
	for i in range(2+ceil(Global.wave*1.67)): # number of enemies to spawn
		var r := randf()
		if r < 0.05:
			spawn_enemy(EnemyInfoResource.EnemyType.BLOB)
		elif r < 0.15:
			spawn_enemy(EnemyInfoResource.EnemyType.BEETLE)
		else:
			spawn_enemy(EnemyInfoResource.EnemyType.FLY)

		await get_tree().create_timer(70/(speed)).timeout

func skip_between_waves():
	skip_wait = true
	
	
func follow_path() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass
	#if randf() < 0.05:
		#spawn_enemy()
	#elif randf() < 0.01:
		#spawn_enemy("mosquito")
