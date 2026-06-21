extends PixelMenu
class_name Game

signal win_rate_changed(new_rate:int)
var win_rate := 0 :
	set(val):
		if win_rate == val: return
		win_rate = val
		win_rate_changed.emit(val)
var tower_inventory: Array[TowerInfo.TowerType] = []
const Type = TowerInfo.TowerType
var weights = {
	Type.LOW : 0.6,
	Type.MID : 0.3,
	Type.HIGH : 0.1,
}

func _ready() -> void:
	Global.game_scene_ref = self
	tower_inventory = [TowerInfo.TowerType.LOW]
	#if OS.is_debug_build():
		#add_towers_to_place(2)

func picked_at_index(idx:int) -> void:
	if tower_inventory.size() == 0: return
	idx = clampi(idx, 0, tower_inventory.size()-1)
	tower_inventory.remove_at(idx)

func add_towers_to_place(num:int) -> void:
	num = clampi(num, 0, 2)
	tower_inventory.clear()
	if num == 0: return
		
	for i in range(num):
		tower_inventory.append(get_random_tower_type(i))
	print("Towers: %s" % str(tower_inventory))
	
func get_random_tower_type(seed:int) -> TowerInfo.TowerType:
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(seed * Time.get_ticks_msec())
	var rand = rng.randf()
	if rand > 1. - weights[Type.HIGH]:
		return Type.HIGH
	elif rand > 1. - weights[Type.HIGH] - weights[Type.MID]:
		return Type.MID
	else: 
		return Type.LOW

func get_towers_to_place() -> Array[TowerInfo.TowerType]:
	return tower_inventory


func start_anim(): 
	Global.state = Global.States.GAME

func end_anim(): self.hide()
