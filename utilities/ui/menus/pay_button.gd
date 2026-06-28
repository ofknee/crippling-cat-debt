extends DefaultButton
class_name PayButton

signal paid
signal price_changed(new_price:int)
@export var price : int = 1000 :
	set(val):
		if val == price: return
		price = val
		price_changed.emit(val)

func _can_pay() -> bool:
	var p = Global.game_scene_ref.purrency
	#print("Game state: %s\nMap State: %s\nprice: %s" % [Global.state, Global.map_state, p])
	#HACK FIgure out why Global.state is always Global.States.START and not Global.States.GAME
	if p >= price and \
		#(Global.state == Global.States.GAME) and \
		Global.map_state != Global.MapStates.WHEEL: 
			return true
	return false


func _process(_delta: float) -> void:
	if not self.visible: return
	self.modulate.a = 1. if _can_pay() else 0.5
func _on_pressed() -> void:
	super()
	if _can_pay(): 
		Global.game_scene_ref.pay(price)
		paid.emit()
