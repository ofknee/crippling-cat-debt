extends Node2D

@onready var tutorial = $Tutorial
#@onready var tutorial_panel = $Tutorial/TutorialPanel
@onready var tutorial_text = $Tutorial/TutorialText

var text = [
	"fjlakncamlskdf;ajweifj",
	"THE JACKPAWT MACHINE IS QUITE CLEARLY BUGGED.",
	"PLACE TOWERS, KILL BUGS, EARN PURRENCY",
	"USE PURRENCY TO...",
	"SPIN A WHEEL FOR MORE (OR LESS) TOWERS!\n\nUPGRADE YOUR TOWERS!!\n\nBUY BETTER ODDS ON THE MACHINE!!!",
	"YOUR DEVOTEE AWAITS. FIX THE MACHINE.\n(CURING THE ADDICTAION IS... A PROBLEM FOR LATER.)",
	"OR DON'T KILL THE BUGS! WATCH YOUR DEVOTEE FALL INTO GREATER DEBT AND DOOM AND DESPAIR AND ALLAT!!!!",
	"MAY THE mODDSm BE EVER IN YOUR FAVOR o\nqsusq"
]
var tutorial_already_shown := false
var text_index := 0
var tutorial_open := false

func _ready() -> void:
	tutorial_text.pivot_offset_ratio = Vector2.ONE * 0.5
	hide()
	Global.map_state = Global.MapStates.TUTORIAL	#SignalBus.state_changed.connect(_on_state_changed)

func _process(_delta: float) -> void:
	if Global.map_state == Global.MapStates.TUTORIAL and not tutorial_already_shown:
		show_tutorial()


#func _on_state_changed(new_state) -> void:
	#if new_state == SignalBus.States.GAME:
		#show_tutorial()
func show_tutorial() -> void:
	tutorial_already_shown = true
	tutorial_open = true
	text_index = 0
	tutorial_text.text = text[text_index]

	show()
	tutorial.scale = Vector2.ZERO

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(tutorial, "scale", Vector2.ONE, 0.35)

func _input(event: InputEvent) -> void:
	if not tutorial_open:
		return

	if event is InputEventMouseButton and event.pressed:
		next_text()

func next_text() -> void:
	text_index += 1

	if text_index >= text.size():
		hide()
		return

	var tween := create_tween()
	
	tween.tween_property(tutorial_text, "scale", Vector2(0.5, 0.5), 0.15)

	await tween.finished

	tutorial_text.text = text[text_index]

	tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(tutorial_text, "scale", Vector2.ONE, 0.25)

	#tutorial_text.text = text[text_index]
