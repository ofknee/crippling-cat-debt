extends Control
class_name TowerSelection
@onready var popup: Panel = $Popup


func _ready() -> void:
	Global.tower_selected.connect(_on_tower_selected)
	popup.hide()
	
func _on_tower_selected(tower:Tower, type:Global.SelectionType) -> void:
	if type != Global.SelectionType.INFO: return
	#TODO Move the popup so its not outside the viewport
	var target = tower.global_position
	var viewport_size = get_viewport_rect().size
	
	var left_margin = viewport_size.x * 0.05
	var right_margin = viewport_size.x * 0.05
	var top_margin = viewport_size.y * 0.10
	var bottom_margin = viewport_size.y * 0.10
	var popup_size = popup.get_global_rect().size
	target.x = clamp(
		target.x,
		left_margin,
		viewport_size.x - popup_size.x - right_margin
	)
	target.y = clamp(
		target.y,
		top_margin,
		viewport_size.y - popup_size.y - bottom_margin
	)
	popup.open_popup()
	popup.global_position = target
