class_name SelectionPopup
extends Panel

@export var but: PayButton
@export var title: RichTextLabel
#@onready var price: RichTextLabel = $VBoxContainer/ButtonCont/DefaultButton/Text
@export var price: RichTextLabel
var t : Tower

func _ready() -> void:
	but.paid.connect(_on_upgrade_pressed)

func open_popup() -> void:
	self.show()
	t = Global.selected_tower
	t.popupped = true
func close_popup() -> void:
	self.hide()
	if t:
		t.popupped = false
	t = null
	

func _unhandled_input(event: InputEvent):
	if visible and t.popupped and event is InputEventMouseButton and event.pressed:
		var rect = get_global_rect()
		
		if not rect.has_point(event.position):
			Global.clear_selected_tower()
			close_popup()

func _process(_delta: float) -> void:
	#TODO event based ui updates
	_update_ui()


func _on_upgrade_pressed() -> void:
	print("clicked: %s" % t)
	if not t: return
	var stats = EntityDatabase.get_leveled_tower(t.type, t.level)
	SignalBus.upgrade_selected_tower.emit(t.level, stats.upgrade_price)
	t.level += 1
	print("Leveling up, new level: %s" % t.level)
	pass

func _update_ui() -> void:
	#var t = Global.selected_tower
	if not t: return
	var stats := EntityDatabase.get_leveled_tower(t.type, t.level)
	var up_price = int(roundf(stats.upgrade_price))
	title.text = "[font top=-10 bt=-0]LEVEL %s" % (t.level+1)
	price.text = "[font top=-20 bt=-20]UPGRADE\n%s COINS" % str(up_price)
	but.price = up_price
	
	# update level, price, and the availability of the button
