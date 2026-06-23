extends Sprite2D

@onready var tower_button1 = $"../TowerButtonCont/Tower1" 
@onready var tower_button2 = $"../TowerButtonCont/Tower2" 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tower_button1.visible==false and tower_button2.visible==false:
		hide()
	else:
		show()
