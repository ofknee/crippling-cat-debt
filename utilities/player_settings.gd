extends Node
class_name PlayerSettings

@export var master_volume := 1.0 :
	set(val):
		master_volume = val
		var idx = AudioServer.get_bus_index("Master")
		if val > .005:
			AudioServer.set_bus_mute(idx, false)
			var db = clampf(val, .005, 2.0)
			db = linear_to_db(db)
			AudioServer.set_bus_volume_db(
				idx,
				db
			)
			#print("New db: %s" % db)
		else:
			AudioServer.set_bus_mute(idx, true)
			#print("Muted")
@export var game_volume := 1.0
@export var cutscene_sounds := 1.0
#@export var show_tutorial := true
