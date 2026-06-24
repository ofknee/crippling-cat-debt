extends PixelMenu
class_name PauseScreen

func _ready() -> void:
	Global.map_state_changed.connect(_on_map_state_changed)

func _on_map_state_changed(new_state:Global.MapStates) -> void:
	pass

func start_anim() -> void: pass
func end_anim() -> void: pass
