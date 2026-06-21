extends RichTextLabel
@export var odds = Global.odds
var t: Tween


func _ready():
	scale = Vector2.ONE
	text = "[color=red][font top=-30]0j WIN"
	SignalBus.change_odds.connect(inc_odds)


func get_odds():
	return odds
	
func set_odds(amount: int):
	odds = clampi(amount, -100, 100)
	self.text = "[color=red][font top=-30]" + str(odds) + "j WIN"
	if odds <= -1:
		print("LOST")
		SignalBus.lose.emit()
	elif odds == 100:
		print("WON")
		SignalBus.win.emit()

func inc_odds(amount: int):
	self.scale = Vector2.ONE
	if t and t.is_running(): t.kill()
	t = create_tween().set_ease(Tween.EASE_OUT)
	t.set_parallel(true).set_trans(Tween.TRANS_QUINT)
	t.tween_property(self, "scale", Vector2.ONE * 0.05, 0.2)
	#TODO Green text when winning
	t.tween_property(self, "offset_transform_position", Vector2(-5, -5), 0.2)
	await t.finished
	t = create_tween().set_ease(Tween.EASE_OUT)
	t.set_parallel(true).set_trans(Tween.TRANS_QUINT)
	set_odds(odds+amount)
	t.tween_property(self, "scale", Vector2.ONE, 0.2)
	t.tween_property(self, "offset_transform_position", Vector2.ZERO, 0.2)
	await t.finished
	

func _on_game_win_rate_changed(new_rate: int) -> void:
	if new_rate > odds: inc_odds(new_rate-odds)
	else: set_odds(new_rate)
