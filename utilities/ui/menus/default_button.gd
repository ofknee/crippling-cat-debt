extends Button
class_name DefaultButton

var t : Tween

func _ready() -> void:
	self.pivot_offset_ratio = Vector2(0.5, 0.5)
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	var _t = create_tween().set_ease(Tween.EASE_OUT)
	_t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	_t.tween_property(self, "scale", Vector2.ONE*0.9, 0.08)
	_t.tween_property(self, "scale", Vector2.ONE*1.1, 0.08).set_delay(0.08)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			_hover()
		NOTIFICATION_MOUSE_EXIT:
			_unhover()

func _hover() -> void:
	if t and t.is_running(): t.kill()
	t = create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	t.tween_property(self, "scale", Vector2.ONE * 1.1, 0.7)
	t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	t.tween_property(self, "offset_transform_rotation", 0.1, 0.2)
	t.tween_property(self, "offset_transform_rotation", -0.1, 0.2).set_delay(0.2)
	t.tween_property(self, "offset_transform_rotation", 0.0, 0.2).set_delay(0.4)

func _unhover() -> void:
	if t and t.is_running(): t.kill()
	t = create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	t.tween_property(self, "scale", Vector2.ONE, 0.7)
	t.set_trans(Tween.TRANS_ELASTIC)
	t.tween_property(self, "offset_transform_rotation", 0.0, 0.4)
