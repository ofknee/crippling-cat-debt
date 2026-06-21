extends PixelMenu
class_name BeginningCutscene
enum States {
	START,
	MAIN,
	END,
}
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var odds_text: RichTextLabel = $OddsText
@onready var debt_text: RichTextLabel = $DebtText
@onready var debt_text_2: RichTextLabel = $DebtText2
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

@export var slot_sfx: AudioStreamMP3
@export var vine_boom: AudioStreamMP3

var cutscene_state : States = States.START
const GAME = preload("res://scenes/game.tscn")
var ts : Array[Tweenable]
var t : Tween

func _ready():
	start_anim()

## Call when the cutscene is finished and go to the game
func end_cutscene() -> void:
	print("To game")
	Global.menu_manager.transition_to_scene(GAME)
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		if cutscene_state != States.MAIN: return
		if Global.state == Global.States.GAME: return
		# now its defo main
		if t and t.is_running(): t.kill()
		Global.menu_manager.transition_to_scene(GAME)

func start_anim():
	self.cutscene_state = States.START
	anim.animation = "cut_scene"
	anim.position = Vector2(520, 350)
	odds_text.modulate.a = 0.0
	odds_text.offset_transform_enabled = true
	odds_text.offset_transform_position = Vector2.ZERO
	debt_text.modulate.a = 0.0
	debt_text_2.modulate.a = 0.0
	anim.scale = Vector2.ZERO
	await get_tree().create_timer(1.0).timeout
	t = default_tween().set_ease(Tween.EASE_IN)
	t.tween_property(anim, "scale", Vector2.ONE * 0.4, 1.0)
	await t.finished
	await get_tree().create_timer(0.5).timeout
	await _anim_slots()
	await get_tree().create_timer(1.0).timeout
	await _turning_cat()
	Global.menu_manager.transition_to_scene(GAME)

func _anim_slots():
	self.cutscene_state = States.MAIN
	anim.play("cut_scene")
	audio_player.stream = slot_sfx
	sfx_tween_in(0.2)
	await anim.animation_finished
	sfx_tween_out(0.2)
	if t and t.is_running(): t.kill()
	t = default_tween()
	debt_text.offset_transform_position.y = 0.0
	debt_text.modulate.a = 1.0
	t.tween_property(debt_text, "offset_transform_position:y", -50., 0.7)
	t.tween_property(debt_text, "modulate:a", 0.0, 0.3).set_delay(0.4)
	await t.finished
	
	t = default_tween()
	t.tween_property(odds_text, "modulate:a", 1., 0.7)
	t.tween_property(odds_text, "offset_transform_position:x", 200., 0.7)
	await t.finished
	
	anim.play("cut_scene")
	sfx_tween_in(0.2)
	await anim.animation_finished
	sfx_tween_out(0.2)
	if t and t.is_running(): t.kill()
	t = default_tween()
	debt_text.offset_transform_position.y = 0.0
	debt_text.modulate.a = 1.0
	t.tween_property(debt_text, "offset_transform_position:y", -50., 0.7)
	t.tween_property(debt_text, "modulate:a", 0.0, 0.3).set_delay(0.4)
	t.tween_property(odds_text, "modulate:a", 0.0, 0.3).set_delay(0.4)

func _turning_cat():
	self.cutscene_state = States.MAIN
	anim.scale = Vector2.ONE * 0.3
	anim.position = Vector2(576, 324)
	anim.play("turning_cat")
	await anim.animation_finished
	if t and t.is_running(): t.kill()
	t = default_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(anim, "scale", Vector2.ONE, 1.7)
	t.tween_property(anim, "position", Vector2(624, 840), 1.7)
	await t.finished
	# Debt text final
	if t and t.is_running(): t.kill()
	t = default_tween()
	debt_text_2.offset_transform_position.y = 0.0
	debt_text_2.modulate.a = 1.0
	audio_player.stream = vine_boom
	sfx_tween_in(0.05)
	t.tween_property(debt_text_2, "offset_transform_position:y", -50., 0.7)
	t.tween_property(debt_text_2, "modulate:a", 0.0, 0.3).set_delay(0.4)
	await t.finished
	sfx_tween_out(0.05)
	await get_tree().create_timer(1.0).timeout

func end_anim():
	self.cutscene_state = States.END
	if t and t.is_running(): t.kill()
	t = default_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.7)
	await get_tree().create_timer(0.7).timeout
	queue_free()
	
func sfx_tween_in(duration: int):
	var sfx_t: Tween = create_tween()
	sfx_t.set_ease(Tween.EASE_OUT)
	sfx_t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	
	audio_player.volume_db = -50
	audio_player.play()
	sfx_t.tween_property(audio_player, "volume_db", 0, duration)
	
func sfx_tween_out(duration: int):
	var sfx_t: Tween = create_tween()
	sfx_t.set_ease(Tween.EASE_OUT)
	sfx_t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	
	audio_player.volume_db = 0
	sfx_t.tween_property(audio_player, "volume_db", -50, duration)
	await sfx_t.finished
	audio_player.stop()
