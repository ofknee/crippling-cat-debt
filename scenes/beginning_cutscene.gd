extends PixelMenu
class_name BeginningCutscene

const GAME = preload("res://scenes/game.tscn")
var ts : Array[Tweenable]
var t : Tween

## Call when the cutscene is finished and go to the game
func end_cutscene() -> void:
	print("To game")
	Global.menu_manager.transition_to_scene(GAME)

func start_anim():
	ts = get_all_tweenables(self)
	if t != null and t.is_running(): t.kill()
	t = default_tween()
	for _t in ts:
		var f = _t.get_final_offset()
		_t.par.offset_transform_position = f
		t.tween_property(_t.par, "offset_transform_position", Vector2.ZERO, 3.)
	
	t.tween_property($test as TextureRect, "rotation_degrees", 360, 5.0)
	t.set_parallel(false)
	t.tween_callback(end_cutscene)

func end_anim():
	if t != null and t.is_running(): t.kill()
	t = default_tween()
	t.tween_property(self, "modulate:a", 0.0, 1.0)
	
