extends PixelMenu
class_name Game

signal win_rate_changed(new_rate:int)
var win_rate := 0 :
	set(val):
		if win_rate == val: return
		win_rate = val
		win_rate_changed.emit(val)

func get_towers_to_place() -> Array[TowerInfo.TowerType]:
	return [TowerInfo.TowerType.LOW, TowerInfo.TowerType.LOW]

func _ready() -> void:
	Global.game_scene_ref = self

func start_anim(): 
	Global.state = Global.States.GAME

func end_anim(): self.hide()
