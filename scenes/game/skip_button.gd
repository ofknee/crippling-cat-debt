extends MarginContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not Global.spawn_manager: return
	var sm = Global.spawn_manager
	self.modulate.a = 1.0 if sm.can_skip else 0.5
