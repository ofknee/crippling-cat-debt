extends PixelMenu
class_name SettingsMenu

const S = StartMenu.States
@export var volume_slider : DefaultSlider
@export var back_button : DefaultButton
var t : Tween

@export var start_menu:StartMenu

func _ready() -> void:
	volume_slider.value_changed.connect(func(new_val:float):
		Global.settings.master_volume = clampf(new_val, 0.0, 2.0)
	)
	back_button.pressed.connect(func():
		unpause()
	)

func unpause():
	start_menu.go_to_state(S.START)


func start_anim() -> void: 
	if t and t.is_running(): t.kill()
	t = default_tween()
	
	t.tween_property(start_menu, "global_position", Vector2(get_viewport_rect().size.x,0), 0.7)

func end_anim() -> void: 
	if t and t.is_running(): t.kill()
	t = default_tween()
	t.tween_property(start_menu, "global_position", Vector2(0,0), 0.7)
