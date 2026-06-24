extends Node2D
class_name Map

func _ready() -> void: 
	Global.map = self
	SignalBus.lose_tower.connect(_on_lose_tower)
func _exit_tree() -> void: Global.map = null

func _on_lose_tower() -> void:
	var tm := Global.tower_manager
	if tm.all_towers.size() == 0: 
		push_warning("No towers to delete")
		return
	var die = tm.all_towers.pick_random()
	die.queue_free()
	#tm.deregister_tower()
