extends PixelMenu
class_name StartMenu

const BEGINNING_CUTSCENE = preload("res://scenes/beginning_cutscene.tscn")

@export var buttons : Array[Button]
var ts : Array[Tweenable]
var t : Tween

func _ready() -> void:
	for button in buttons:
		button.pressed.connect(Callable(_on_button_pressed)\
			.bind(button.name))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("w"):
		start_anim()

func _on_button_pressed(button_name:String) -> void:
	match button_name.to_lower():
		"play":
			pass
			print("play")
			Global.menu_manager.transition_to_scene(BEGINNING_CUTSCENE)
		"quit":
			pass

func start_anim():
	ts = get_all_tweenables(self)
	if t != null and t.is_running(): t.kill()
	t = default_tween()
	for _t in ts:
		var f = _t.get_final_offset()
		_t.par.offset_transform_position = f
		t.tween_property(_t.par, "offset_transform_position", Vector2.ZERO, 3.)


func end_anim():
	ts = get_all_tweenables(self)
	if t != null and t.is_running(): t.kill()
	t = default_tween()
	for _t in ts:
		var f = _t.get_final_offset()
		_t.par.offset_transform_position = Vector2.ZERO
		t.tween_property(_t.par, "offset_transform_position", f, .7)
	t.chain()
	t.tween_property(self, "modulate:a", 0.0, 0.7)
	t.chain()

	
