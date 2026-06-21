extends CanvasLayer
class_name UI
const TOWER_SCENE = preload("res://scenes/entities/tower.tscn")
@onready var place_tower_ui: Control = $PlaceTowerUI
@onready var tower_button_cont: HBoxContainer = $TowerButtonCont
@onready var tower_1: DefaultButton = $TowerButtonCont/Tower1
@onready var tower_2: DefaultButton = $TowerButtonCont/Tower2
var map_ref : Map

func _ready() -> void:
	place_tower_ui.hide()
	Global.map_state_changed.connect(_on_map_state_changed)
	for but in tower_button_cont.get_children():
		var button = but as DefaultButton
		if not button: continue
		button.pressed.connect(_on_button_pressed.bind(button.name))

func _process(_delta: float) -> void:
	var ts = Global.game_scene_ref.get_towers_to_place()
	if ts.size() >= 2:
		tower_1.show()
		tower_1.set_text_label("[font_size=60]"+TowerInfo.stats.get(ts[0])["name"].to_upper())
		tower_2.show()
		tower_2.set_text_label("[font_size=60]"+TowerInfo.stats.get(ts[0])["name"].to_upper())
	elif ts.size() == 1:
		tower_1.show()
		tower_1.set_text_label("[font_size=60]"+TowerInfo.stats.get(ts[0])["name"].to_upper())
		tower_2.hide()
	else:
		tower_1.hide()
		tower_2.hide()

func _on_button_pressed(_name:String):
	var ts = Global.game_scene_ref.get_towers_to_place()
	match _name.to_lower():
		# Temporary names for buttons
		"tower1":
			if Global.selected_tower and not Global.selected_tower.placed:
				Global.selected_tower.queue_free()
			Global.selected_tower = TOWER_SCENE.instantiate()
			Global.selected_tower.type = ts[0]
			tower_1.set_text_label("[font_size=60][font bt=-40]"+Global.selected_tower._get_stats()["name"].to_upper())
		"tower2":
			if Global.selected_tower and not Global.selected_tower.placed:
				Global.selected_tower.queue_free()
			Global.selected_tower = TOWER_SCENE.instantiate()
			Global.selected_tower.type = ts[1]
			tower_2.set_text_label("[font_size=60][font bt=-40]"+Global.selected_tower._get_stats()["name"].to_upper())

func _on_map_state_changed(new_state:Global.MapStates) -> void:
	match new_state:
		Global.MapStates.PLACE:
			place_tower_ui.show()
			return
	
	place_tower_ui.hide()
