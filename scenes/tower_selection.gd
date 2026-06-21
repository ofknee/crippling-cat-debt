extends Control
class_name TowerSelection
@onready var popup: Panel = $Popup

func _ready() -> void:
	Global.tower_selected.connect(_on_tower_selected)
	popup.focus_exited.connect(_on_popup_focus_exited)
	popup.hide()
	
func _on_tower_selected(tower:Tower, type:Global.SelectionType) -> void:
	if type != Global.SelectionType.INFO: return
	#TODO Move the popup so its not outside the viewport
	var target = tower.global_position
	var rect = get_viewport_rect()
	popup.open_popup()
	popup.global_position = target

func _on_popup_focus_exited() -> void:
	print("Lost focus")
	popup.hide()
