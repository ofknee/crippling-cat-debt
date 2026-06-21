extends CanvasLayer
class_name UI
const TOWER_SCENE = preload("res://scenes/entities/tower.tscn")
@onready var tower_button_cont: HBoxContainer = $MarginContainer/TowerButtonCont
#@onready var tower_button_cont: MarginContainer = $TowerButtonCont
@onready var wheel_button: DefaultButton = $Wheel/MarginContainer/WheelButton
@onready var tower_1: DefaultButton = $MarginContainer/TowerButtonCont/Tower1
@onready var tower_2: DefaultButton = $MarginContainer/TowerButtonCont/Tower2
@onready var purrency_text: RichTextLabel = $Center/PurrencyText
var map_ref : Map

func _ready() -> void:
	#Global.map_state_changed.connect(_on_map_state_changed)
	wheel_button.paid.connect(func():
		SignalBus.wheel_time.emit()
	)
	for but in tower_button_cont.get_children():
		var button = but as DefaultButton
		if not button: continue
		button.pressed.connect(_on_button_pressed.bind(button.name))

func _process(_delta: float) -> void:
	_update_text()
	var ts = Global.game_scene_ref.get_towers_to_place()
	#print("Towers: %s" % str(ts))
	if ts.size() >= 2:
		tower_1.show()
		tower_1.set_text_label("[font_size=60]"+TowerInfo.stats.get(ts[0])["name"].to_upper())
		tower_2.show()
		tower_2.set_text_label("[font_size=60]"+TowerInfo.stats.get(ts[1])["name"].to_upper())
	elif ts.size() == 1:
		tower_1.show()
		tower_1.set_text_label("[font_size=60]"+TowerInfo.stats.get(ts[0])["name"].to_upper())
		tower_2.hide()
	else:
		tower_1.hide()
		tower_2.hide()

func _update_text() -> void:
	purrency_text.text = "[font top=-50 bt=-30]d%s" % format_number(Global.game_scene_ref.purrency)
	var spins = Global.game_scene_ref.wheel_spins
	var p = exp(spins * .2)
	wheel_button.price = 1000

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
			tower_1.set_text_label("[font_size=60][font bt=-40]"+Global.selected_tower._get_stats()["name"].to_upper())
			Global.game_scene_ref.picked_at_index(0)
		"tower2":
			if Global.selected_tower and not Global.selected_tower.placed:
				Global.selected_tower.queue_free()
				Global.clear_selected_tower()
			var inst = TOWER_SCENE.instantiate()
			Global.select_tower(inst, Global.SelectionType.SPAWN)
			Global.selected_tower.type = ts[1]
			tower_2.set_text_label("[font_size=60][font bt=-40]"+Global.selected_tower._get_stats()["name"].to_upper())
			Global.game_scene_ref.picked_at_index(1)
#func _on_map_state_changed(new_state:Global.MapStates) -> void:
	#match new_state:
		#Global.MapStates.PLACE:
			#place_tower_ui.show()
			#return
	#
	#place_tower_ui.hide()
