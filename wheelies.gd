extends Node2D

@onready var spikey: Node2D = $spikey
@onready var bg  = $spikey/bg
@onready var spin = $spikey/words/spin
@onready var that = $spikey/words/that
@onready var wheel = $spikey/words/wheel

enum {
	
}


func _ready() -> void:
	babang()

func babang() -> void:
	var segments = [bg, spin, that, wheel]

	for part in segments:
		part.scale = Vector2.ZERO

	for part in segments:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_BOUNCE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(part, "scale", Vector2.ONE, 1)

#		await tween.finished
		await get_tree().create_timer(0.3).timeout
