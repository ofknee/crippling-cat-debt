extends Node

var odds : int = 0
var wave : int = 0

enum States {
	START,
	GAME,
}
signal state_changed(new_state:States)
var state: States = States.START :
	set(val):
		if state != val: return
		state = val
		state_changed.emit(val)

var menu_manager : PixelMenuManager

var map : Map
signal map_state_changed(new_state:States)
enum MapStates {
	PLAY,
	PLACE,
	UPGRADE,
	WHEEL,
	TUTORIAL,
}
var map_state : MapStates = MapStates.PLAY :
	set(val):
		if val == map_state: return
		map_state = val
		map_state_changed.emit(val)

enum SelectionType {
	SPAWN,
	INFO,
	NULL,
}
signal tower_selected(tower:Tower, selection_type:SelectionType)
var selected_tower : Tower = null 
func select_tower(tower:Tower, selection_type:SelectionType=SelectionType.NULL):
	selected_tower = tower
	tower_selected.emit(tower, selection_type)
func clear_selected_tower() -> void: selected_tower = null
var tower_manager: TowerManager

var all_enemies: Array[Enemy]
func register_enemy(enemy:Enemy):
	if all_enemies.find(enemy) != -1: return
	all_enemies.append(enemy)
	enemy.tree_exiting.connect(func():
		all_enemies.erase(enemy)
	)

var game_scene_ref: Game
