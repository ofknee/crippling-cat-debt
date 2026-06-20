extends CanvasLayer
class_name UI
const TOWER_SCENE = preload("res://scenes/entities/tower.tscn")
@onready var place_tower_ui: Control = $PlaceTowerUI
@onready var tower_button_cont: GridContainer = $PlaceTowerUI/GridContainer
var map_ref : Map

func _ready() -> void:
	place_tower_ui.hide()
	Global.map_state_changed.connect(_on_map_state_changed)
	for but in tower_button_cont.get_children():
		var button = but as DefaultButton
		if not button: continue
		button.pressed.connect(_on_button_pressed.bind(button.name))

func _on_button_pressed(_name:String):
	match _name.to_lower():
		# Temporary names for buttons
		"tower":
			Global.selected_tower = TOWER_SCENE.instantiate()

func _on_map_state_changed(new_state:Global.MapStates) -> void:
	match new_state:
		Global.MapStates.PLACE:
			place_tower_ui.show()
			return
	
	place_tower_ui.hide()
