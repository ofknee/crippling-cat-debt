extends Node2D
class_name Map


func _ready() -> void: 
	Global.map = self
	SignalBus.lose_tower.connect(_on_lose_tower)
func _exit_tree() -> void: Global.map = null

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("space"):
		#Global.map_state = Global.MapStates.PLACE

func _on_lose_tower() -> void:
	var tm := Global.tower_manager
	tm.deregister_tower(tm.all_towers.pick_random())
