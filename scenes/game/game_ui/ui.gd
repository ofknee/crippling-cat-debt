extends CanvasLayer
class_name UI

const TOWER_SCENE = preload("res://scenes/entities/tower.tscn")
#@onready var tower_button_cont: HBoxContainer = $MarginContainer/TowerButtonCont
#@onready var tower_button_cont: MarginContainer = $TowerButtonCont
#@onready var wheel_button: DefaultButton = $"../Shop/HBoxContainer/Wheel/MarginContainer/WheelButton"
#@onready var odds_button: DefaultButton = $"../Shop/HBoxContainer/BuyOdds/MarginContainer/OddsButton"
#@onready var tower_1: DefaultButton = $MarginContainer/TowerButtonCont/Tower1
#@onready var tower_2: DefaultButton = $MarginContainer/TowerButtonCont/Tower2
#@onready var purrency_text: RichTextLabel = $Center/HBoxContainer/PurrencyText
@export_subgroup("Nodes")
@export var purrency_text: RichTextLabel
@export var tower_button_cont: HBoxContainer
@export var tower_1: DefaultButton 
@export var tower_2: DefaultButton
@export var odds_button : PayButton
@export var wheel_button : PayButton
@export var pause_button : DefaultButton
@export var skip_button: DefaultButton
const TOWER_TEXT_HEADER = "[font_size=60][font bt=-40]"

func _ready() -> void:
	pause_button.pressed.connect(func():
		SignalBus.pause.emit(true)
	)
	skip_button.pressed.connect(func():
		SignalBus.skip_wave.emit()
	)
	wheel_button.paid.connect(func():
		SignalBus.wheel_time.emit()
	)
	odds_button.paid.connect(func():
		SignalBus.change_odds.emit(5)
	)
	
	for but in tower_button_cont.get_children():
		var button = but as DefaultButton
		if not button: continue
		button.pressed.connect(_on_button_pressed.bind(button.name))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("2") and OS.is_debug_build():
		#DEBUG test two towers
		Global.game_scene_ref.tower_inventory = [Global.game_scene_ref.get_random_tower_type(1),Global.game_scene_ref.get_random_tower_type(2)]
	_update_text()
	var ts := Global.game_scene_ref.get_towers_to_place()
	if ts.size() >= 2:
		tower_1.show()
		tower_1.set_text_label(TOWER_TEXT_HEADER+EntityDatabase.get_tower(ts[0]).name.to_upper())
		tower_2.show()
		tower_2.set_text_label(TOWER_TEXT_HEADER+EntityDatabase.get_tower(ts[1]).name.to_upper())
	elif ts.size() == 1:
		tower_1.show()
		tower_1.set_text_label(TOWER_TEXT_HEADER+EntityDatabase.get_tower(ts[0]).name.to_upper())
		tower_2.hide()
	else:
		tower_1.hide()
		tower_2.hide()

func _update_text() -> void:
	purrency_text.text = "[font top=-50 bt=-30]d%s" % format_number(Global.game_scene_ref.purrency)
	var spins = Global.game_scene_ref.wheel_spins
	var p = exp(spins * .20002) * 1000
	wheel_button.price = int(roundf(p))
	var winrate_paid = Global.game_scene_ref.winrate_paid
	var w = exp(winrate_paid * .19923) * 1000
	odds_button.price = int(roundf(w))
	

func format_number(n: int) -> String:
	var s := str(n)
	var result := ""
	while s.length() > 3:
		result = "," + s.substr(s.length() - 3) + result
		s = s.substr(0, s.length() - 3)
	return s + result

func _on_button_pressed(_name:String):
	var ts = Global.game_scene_ref.get_towers_to_place()
	match _name.to_lower():
		# Temporary names for buttons
		"tower1":
			if Global.selected_tower and not Global.selected_tower.placed:
				Global.selected_tower.queue_free()
				Global.clear_selected_tower()
			var inst = TOWER_SCENE.instantiate()
			Global.select_tower(inst, Global.SelectionType.SPAWN)
			Global.selected_tower.type = ts[0]
			print("Tower type: %s" % Global.selected_tower.type)
			tower_1.set_text_label(TOWER_TEXT_HEADER+Global.selected_tower.get_stats().name.to_upper())
			Global.game_scene_ref.picked_at_index(0)
		"tower2":
			if Global.selected_tower and not Global.selected_tower.placed:
				Global.selected_tower.queue_free()
				Global.clear_selected_tower()
			var inst = TOWER_SCENE.instantiate()
			Global.select_tower(inst, Global.SelectionType.SPAWN)
			Global.selected_tower.type = ts[1]
			print("Tower type: %s" % Global.selected_tower.type)
			tower_2.set_text_label(TOWER_TEXT_HEADER+Global.selected_tower.get_stats().name.to_upper())
			Global.game_scene_ref.picked_at_index(1)
