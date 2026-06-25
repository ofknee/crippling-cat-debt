extends Node
class_name PlayerSettings

@export var master_volume := 1.0 :
	set(val):
		master_volume = val
		var db = clampf(val, .005, 2.0)
		db = linear_to_db(db)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"),
			db
		)
		print("New db: %s" % db)
@export var game_volume := 1.0
@export var cutscene_sounds := 1.0
#@export var show_tutorial := true
