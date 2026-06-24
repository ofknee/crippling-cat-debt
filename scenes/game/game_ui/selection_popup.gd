class_name SelectionPopup
extends Panel

@export var but: PayButton
@onready var title: RichTextLabel = $VBoxContainer/Title
@onready var price: RichTextLabel = $VBoxContainer/ButtonCont/DefaultButton/Text
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
	if visible and event is InputEventMouseButton and event.pressed:
		var rect = get_global_rect()
		
		if not rect.has_point(event.position):
			Global.clear_selected_tower()
			close_popup()

func _process(_delta: float) -> void:
	#TODO event based ui updates
	_update_ui()

func _can_buy() -> bool: return true

func _on_upgrade_pressed() -> void:
	print("clicked: %s" % t)
	if not t: return
	var stats = EntityDatabase.get_leveled_tower(t.type, t.level)
	SignalBus.upgrade_selected_tower.emit(t.level, stats["upgrade_price"])
	if _can_buy() or true:
		t.level += 1
		print("Leveling up, new level: %s" % t.level)
	pass

func _update_ui() -> void:
	#var t = Global.selected_tower
	if not t: return
	var stats := EntityDatabase.get_leveled_tower(t.type, t.level)
	var up_price = int(roundf(stats.upgrade_price))
	title.text = "[font top=-15 bt=-5]LEVEL %s" % (t.level+1)
	price.text = "[font top=-20 bt=-20]UPGRADE\n%s COINS" % str(up_price)
	but.price = up_price
	
	# update level, price, and the availability of the button
