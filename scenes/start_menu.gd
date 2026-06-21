extends PixelMenu
class_name StartMenu

const BEGINNING_CUTSCENE = preload("res://scenes/beginning_cutscene.tscn")

@export var buttons : Array[Button]
var ts : Array[Tweenable]
var t : Tween

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@export var gary_meow: AudioStreamMP3

func _ready() -> void:
	audio_player.stream = gary_meow
	self.offset_transform_enabled = true
	for button in buttons:
		button.pressed.connect(Callable(_on_button_pressed)\
			.bind(button.name))


func _on_button_pressed(button_name:String) -> void:
	audio_player.play()
	match button_name.to_lower():
		"play":
			pass
			print("play")
			Global.menu_manager.transition_to_scene(BEGINNING_CUTSCENE)
		"quit":
			pass

func start_anim():
	pass

func end_anim():
	if t and t.is_running(): t.kill()
	t = create_tween().set_parallel(true)
	t.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "offset_transform_scale", Vector2.ONE * 10., 1.0)
	t.tween_property(self, "modulate:a", 0.0, 1.0)
