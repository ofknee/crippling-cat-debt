extends Node2D
class_name Map


func _ready() -> void: Global.map = self
func _exit_tree() -> void: Global.map = null

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		Global.map_state = Global.MapStates.PLACE
