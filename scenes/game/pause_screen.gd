extends PixelMenu
class_name PauseScreen

const MS = Global.MapStates
@export var volume_slider : DefaultSlider

func _ready() -> void:
	Global.map_state_changed.connect(_on_map_state_changed)
	self.hide()
	volume_slider.value_changed.connect(func(new_val:float):
		Global.settings.master_volume = clampf(new_val, 0.0, 2.0)
	)

#DEBUG p for pause
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("p") and OS.is_debug_build() and Global.map_state == MS.PLAY:
		Global.map_state = MS.PAUSE
		get_tree().paused = true
		print("PAUSED")
	elif Input.is_action_just_pressed("p") and OS.is_debug_build() and Global.map_state == MS.PAUSE:
		Global.map_state = MS.PLAY
		get_tree().paused = false
		print("PLAYING")

func _on_map_state_changed(new_state:MS) -> void:
	if new_state == MS.PAUSE:
		start_anim()
		return
	if new_state == MS.PLAY and self.visible:
		end_anim()
		return

func start_anim() -> void: 
	self.show()
func end_anim() -> void: 
	self.hide()
