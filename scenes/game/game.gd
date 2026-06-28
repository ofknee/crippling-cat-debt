extends PixelMenu
class_name Game

const T = TowerInfoResource.TowerType

signal win_rate_changed(new_rate:int)
var win_rate := 0 :
	set(val):
		if win_rate == val: return
		win_rate = val
		win_rate_changed.emit(val)
var tower_inventory: Array[T] = []
var wheel_spins: int = 0
var winrate_paid: int = 0
var weights = {
	T.LOW : 0.6,
	T.MID : 0.3,
	T.HIGH : 0.1,
}
var purrency: int = 1000
var pay_queue: Array[int] = []
#DEBUG 
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("w") and OS.is_debug_build():
		SignalBus.win.emit()
	if Input.is_action_just_pressed("s") and OS.is_debug_build():
		SignalBus.lose.emit()
func _ready() -> void:
	Global.game_scene_ref = self
	tower_inventory = [T.LOW]
	SignalBus.wheel_time.connect(func():
		wheel_spins += 1
	)
	SignalBus.change_odds.connect(func(_n:int):
		winrate_paid += 1
	)
	SignalBus.killed_enemy.connect(func(drop_price:int):
		self.purrency += abs(drop_price)
	)
	SignalBus.win.connect(_on_win)
	SignalBus.lose.connect(_on_lose)

const WIN_CUTSCENE = preload("res://scenes/cutscenes/win_cutscene.tscn")
func _on_win() -> void:
	Global.menu_manager.transition_to_scene(WIN_CUTSCENE)
const LOSE_CUTSCENE = preload("res://scenes/cutscenes/lose_cutscene.tscn")
func _on_lose() -> void:
	Global.menu_manager.transition_to_scene(LOSE_CUTSCENE)

func pay(amount:int) -> void:
	pay_queue.append(amount)
	call_deferred("pay_deferred")

func pay_deferred() -> void:
	while pay_queue.size() > 0:
		var amount = pay_queue.pop_front()
		if not amount : continue
		if amount > purrency: return
		purrency -= amount

func picked_at_index(idx:int) -> void:
	if tower_inventory.size() == 0: return
	idx = clampi(idx, 0, tower_inventory.size()-1)
	tower_inventory.remove_at(idx)

func add_towers_to_place(num:int) -> void:
	num = clampi(num, 0, 2)
	#tower_inventory.clear()
	if num == 0: return
		
	for i in range(num):
		tower_inventory.push_front(get_random_tower_type(i))
	while tower_inventory.size() > 2:
		tower_inventory.pop_back()
	
func get_random_tower_type(_seed:int) -> T:
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(_seed * Time.get_ticks_msec())
	var rand = rng.randf()
	if rand > 1. - weights[T.HIGH]:
		return T.HIGH
	elif rand > 1. - weights[T.HIGH] - weights[T.MID]:
		return T.MID
	else: 
		return T.LOW

func get_towers_to_place() -> Array[T]:
	return tower_inventory


func start_anim(): 
	Global.state = Global.States.GAME

func end_anim(): 
	self.hide()
	queue_free()
