extends Control
class_name Tutorial
@onready var bg: ColorRect = $bg
var t : Tween
@export var skip_but : DefaultButton
signal next_section
@export_group("Click tower")
@export var tower_but : DefaultButton
@export var click_tower: Control 
signal select_tower_section
@export_group("Place Tower")
@export var place_tower: Control
@export_group("Pause Skip")
@export var pause_skip: Control
@export_group("Odds")
@export var odds: Control
@export var odds_show: Array[Control]
@export_group("Tower")
@export var tower_wheel: Control
@export var wheel_but: Control
signal tutorial_ended


func _ready() -> void:
	Global.map_state_changed.connect(_on_ms_changed)
	bg.hide()
	click_tower.hide()
	place_tower.hide()
	pause_skip.hide()
	tower_wheel.hide()
	odds.hide()
	tower_but.pressed.connect(func():
		select_tower_section.emit()
	)
	skip_but.pressed.connect(func(): end_tutorial())

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space") or Input.is_action_just_pressed("l_click") and visible:
		next_section.emit()
func _on_ms_changed(new_state: Global.MapStates) -> void:
	if new_state != Global.MapStates.TUTORIAL: return
	do_tutorial()
func do_tutorial() -> void:
	if t and t.is_running(): t.kill()
	#t = create_tween().set_ease(Tween.EASE_OUT)
	#t.set_parallel(true).set_trans(Tween.TRANS_QUINT)
	
	# Select tower
	bg.show()
	tower_but.z_index = 100
	click_tower.show()
	if not visible: return
	await select_tower_section
	tower_but.z_index = 0
	click_tower.hide()
	
	# Place tower
	bg.hide()
	place_tower.show()
	if not visible: return
	await Global.selected_tower_cleared
	place_tower.hide()
	
	# Pause/Skip buttons
	bg.show()
	pause_skip.show()
	if not visible: return
	await next_section
	pause_skip.hide()
	
	# Odds highlight
	odds.show()
	for item in odds_show:
		item.z_index = 100
	if not visible: return
	await next_section
	for item in odds_show:
		item.z_index = 0
	odds.hide()

	# Wheel to get tower
	tower_wheel.show()
	bg.show()
	wheel_but.z_index = 100
	if not visible: return
	await SignalBus.wheel_time
	tower_wheel.hide()
	wheel_but.z_index = 0
	end_tutorial()
	#t.twee

func end_tutorial() -> void:
	Global.map_state = Global.MapStates.PLAY
	self.hide()
	tutorial_ended.emit()
