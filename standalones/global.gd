extends Node


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
}
var map_state : MapStates = MapStates.PLAY :
	set(val):
		if val == map_state: return
		map_state = val
		map_state_changed.emit(val)
signal tower_selected(tower:Tower)
var selected_tower : Tower = null :
	set(val):
		if val:
			selected_tower = val
			tower_selected.emit(val)

var all_enemies: Array[Enemy]
func register_enemy(enemy:Enemy):
	if all_enemies.find(enemy) != -1: return
	all_enemies.append(enemy)
	enemy.tree_exiting.connect(func():
		all_enemies.erase(enemy)
	)

var game_scene_ref: Game
