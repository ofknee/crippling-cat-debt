extends Node2D

@onready var bg = $spikey/bg
@onready var spin_word = $spikey/words/spin
@onready var that_word = $spikey/words/that
@onready var wheel_word = $spikey/words/wheel
@onready var wheelfr = $gambler/wheelfr
@onready var result_panel = $ResultInfo/ResultPanel
@onready var result_label = $ResultInfo/ResultLabel
@onready var tick = $gambler/tick
var last_tick_index := -1

var slots = [
	{"name": "+1", "start": 0.0, "end": 72.0*1},
	{"name": "nothing", "start": 72.0*1, "end": 72.0*2},
	{"name": "-1", "start": 72.0*2 , "end": 72.0*3},
	{"name": "+1", "start": 72.0*3, "end": 72.0*4},
	{"name": "+2", "start": 72.0*4, "end": 72.0*4.5},
	{"name": "-1", "start": 72.0*4.5, "end": 72.0*5},
]

func _ready() -> void:
	$gambler.hide()
	$spikey.hide()
	$ResultInfo.hide()
	await babang()
	spin_to_win()
	
func babang() -> void:
	
	$spikey.show()

	var segments = [spin_word, that_word, wheel_word]

	for part in segments:
		part.scale = Vector2.ZERO
	#bg.scale = Vector2.ZERO
	#segments[0].scale = Vector2.ZERO
	#segments[1].scale = Vector2.ZERO
	#segments[2].scale = Vector2(3,3)

	await pop_in_tween(bg, 0.6)
	$spikey/jetspray.play()
	for part in segments:
		await pop_in_tween(part)
		await get_tree().create_timer(0.05).timeout
	
	await get_tree().create_timer(1.0).timeout
	$spikey.hide()
func pop_in_tween(part: Node2D, duration : float = 0.8) -> void:
	var final_pos := part.position

	#part.scale = Vector2.ZERO
	#part.show()

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(part, "scale", Vector2.ONE, duration)

	#await tween.finished
	await get_tree().create_timer(0.1).timeout
#func spin_to_win():
		#var tween := create_tween()
		#tween.set_trans(Tween.TRANS_ELASTIC)
		#tween.set_ease(Tween.EASE_OUT)
		#tween.tween_property(part, "scale", Vector2.ONE, duration)
	
	
func spin_to_win():
	
	var to_be_rotated = randf()*360*2 + 360*2
	var to_be_finally = wheelfr.rotation_degrees + to_be_rotated
	#position.y+=1000
	$gambler.show()	
	
	#var bounce := create_tween()
	#bounce.set_trans(Tween.TRANS_ELASTIC)
	#bounce.set_ease(Tween.EASE_OUT)
	#bounce.tween_property(wheelfr, "position", Vector2.ZERO, 0.25)
	#await bounce.finished

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	last_tick_index = get_slot_index()

	tween.tween_method(
		func(yeah):
			wheelfr.rotation_degrees = yeah
			check_tick(),
		wheelfr.rotation_degrees,
		to_be_finally,
		3.0
	)

	await tween.finished
	
	$gambler/pointer.hide()
	var result = get_landed_slot()
	print("landed on: ", result)
	
	match result:
		"+2":
			show_result("YOU WON TWO TOWERS!")
			$ResultInfo/DuoCorrect.play()
		"+1":
			show_result("YOU WON ONE TOWER!")
			$ResultInfo/DuoCorrect.play()
		"nothing":
			show_result("YOU WON ABSOLUTELY NOTHING!")
			$ResultInfo/DuoWrong.play()
		"-1":
			show_result("YOU GET TO LOSE A TOWER!")
			$ResultInfo/DuoWrong.play()


			SignalBus.lose_tower.emit()



func get_landed_slot() -> String:
	var angle = fmod(wheelfr.rotation_degrees, 360.0)

	for slot in slots:
		if angle >= slot["start"] and angle < slot["end"]:
			return slot["name"]

	return "unknown"
	
func show_result(text: String):
	$ResultInfo.show()
	result_label.text = text
	

	result_panel.show()
	result_label.show()
	result_panel.scale = Vector2.ZERO
	result_label.modulate.a = 0.0
	
	var tween = create_tween()

	
	tween.parallel().tween_property(wheelfr, "scale", Vector2(1.4, 0.6), 0.08)
	tween.chain().tween_property(wheelfr, "scale", Vector2(0.9, 1.1), 0.06)
	tween.chain().tween_property(wheelfr, "scale", Vector2.ZERO, 0.08)

	tween.parallel().tween_property(result_panel,"scale",Vector2.ONE,0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(result_label,"modulate:a",1.0,0.15)

func get_slot_index() -> int:
	var angle = fposmod(wheelfr.rotation_degrees, 360.0)

	for i in range(slots.size()):
		if angle >= slots[i]["start"] and angle < slots[i]["end"]:
			return i

	return -1


func check_tick():
	var current_index = get_slot_index()

	if current_index != last_tick_index and current_index != -1:
		tick.play()
		last_tick_index = current_index
