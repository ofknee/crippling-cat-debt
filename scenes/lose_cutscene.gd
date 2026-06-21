extends PixelMenu
class_name LoseCutscene

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var ts : Array[Tweenable]
var t : Tween

func _ready():
	start_anim()

func start_anim():
	anim.scale = Vector2.ONE * 0.2
	anim.position = Vector2(605, 350)
	await _anim_pain()

func _anim_pain():
	anim.play("cut_scene")
	await anim.animation_finished
	if t and t.is_running(): t.kill()
	t = default_tween()
	t.tween_property(anim, "scale", Vector2.ONE * 0.4, 2)
	t.tween_property(anim, "position", Vector2(812, 350), 2)
	
