extends Node

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

@warning_ignore("unused_signal")
signal wave_finished(num:int)
@warning_ignore("unused_signal")
signal lose_tower()
@warning_ignore("unused_signal")
signal upgrade_selected_tower(new_level:int, price:int)
@warning_ignore("unused_signal")
signal wheel_time()
@warning_ignore("unused_signal")
signal killed_enemy(drop_price:int)
@warning_ignore("unused_signal")
signal change_odds(amt:int)
@warning_ignore("unused_signal")
signal win()
@warning_ignore("unused_signal")
signal lose()
@warning_ignore("unused_signal")
signal toggle_music(on:bool)
