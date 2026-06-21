extends PixelMenu
class_name StartMenu

const BEGINNING_CUTSCENE = preload("res://scenes/cutscenes/beginning_cutscene.tscn")
@onready var declined := $QuitText

@export var buttons : Array[Button]
var ts : Array[Tweenable]
var t : Tween

var audio_players: Array[AudioStreamPlayer]=[]
@export var gary_meow: AudioStreamMP3
@export var miau: AudioStreamMP3

func _ready() -> void:
	for i in 4:
		var ap = AudioStreamPlayer.new()
		add_child(ap)
		audio_players.append(ap)
	self.offset_transform_enabled = true
	for button in buttons:
		button.pressed.connect(Callable(_on_button_pressed)\
			.bind(button.name))


func _on_button_pressed(button_name:String) -> void:
	play_sfx(gary_meow)
	match button_name.to_lower():
		"play":
			pass
			print("play")
			Global.menu_manager.transition_to_scene(BEGINNING_CUTSCENE)
		"quit":
			print("quit")
			var y := -100
			print(y)
			var tween := create_tween()
			tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(declined, "position:y", 60, 0.3)
			tween.tween_interval(1.0)
			tween.tween_property(declined, "position:y", -100, 0.3)
			print(y)

			

func start_anim():
	pass

func end_anim():
	if t and t.is_running(): t.kill()
	t = create_tween().set_parallel(true)
	t.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "offset_transform_scale", Vector2.ONE * 10., 1.0)
	t.tween_property(self, "modulate:a", 0.0, 1.0)
	
func play_miau():
	play_sfx(miau)
	
func play_sfx(stream: AudioStream):
	for p in audio_players:
		if !p.playing:
			p.stream = stream
			p.play()
			return
