extends Sprite2D

@export var tower_button1: DefaultButton 
@export var tower_button2: DefaultButton 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if tower_button1.visible==false and tower_button2.visible==false:
		hide()
	else:
		show()
