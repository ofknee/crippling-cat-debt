extends PixelMenu
class_name WinCutscene

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sad_text: RichTextLabel = $SadText
@onready var audio_player1: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_player2: AudioStreamPlayer = $AudioStreamPlayer2

@export var happy: AudioStreamMP3
@export var vine_boom: AudioStreamMP3
var ts : Array[Tweenable]
var t : Tween

func _ready():
	sad_text.modulate.a = 0
	start_anim()

const START_MENU = preload("res://scenes/start_menu.tscn")
func start_anim():
	anim.scale = Vector2.ONE * 0.3
	await _anim_pain()
	Global.menu_manager.transition_to_scene(START_MENU)

func end_anim():
	Global.menu_manager.toggle_music(true)
	queue_free()

func _anim_pain():
	anim.play("cut_scene")
	audio_player1.stream = happy
	sfx_tween_in(1, 0.05, -10)
	await get_tree().create_timer(3).timeout
	t = default_tween()
	t.tween_property(sad_text, "modulate:a", 1, 0.5) 
	await anim.animation_finished
	await get_tree().create_timer(1.0).timeout
	

func sfx_tween_in(ap: int, duration: float, volume: int):
	var sfx_t: Tween = create_tween()
	sfx_t.set_ease(Tween.EASE_OUT)
	sfx_t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	
	if ap == 1:
		audio_player1.volume_db = -50
		audio_player1.play()
		sfx_t.tween_property(audio_player1, "volume_db", volume, duration)
	elif ap == 2:
		audio_player2.volume_db = -50
		audio_player2.play()
		sfx_t.tween_property(audio_player2, "volume_db", volume, duration)
	
func sfx_tween_out(ap: int, duration: float, volume: int):
	var sfx_t: Tween = create_tween()
	sfx_t.set_ease(Tween.EASE_OUT)
	sfx_t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	
	if ap == 1:
		audio_player1.volume_db = volume
		sfx_t.tween_property(audio_player1, "volume_db", -50, duration)
		await sfx_t.finished
		audio_player1.stop()
	elif ap == 2:
		audio_player2.volume_db = volume
		sfx_t.tween_property(audio_player2, "volume_db", -50, duration)
		await sfx_t.finished
		audio_player2.stop()
	
