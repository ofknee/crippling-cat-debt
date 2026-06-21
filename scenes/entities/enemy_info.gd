extends Node
class_name EnemyInfo

## strength is hwo much it affects odds once hit home base
static var stats := {
	
	"fly" : {
		"strength" : 5,
		"health" : 2.0,
		"speed" : 1.0,
		"drop_price" : 200.0,
		"offset" : Vector2(-158, 134),
	},
	
	"beetle" : {
		"strength" : 10,
		"health" : 4.0,
		"speed" : 1.2,
		"drop_price" : 400.0,
		"offset" : Vector2(0, 52),
	},
	
	"blob" : {
		"strength" : 15,
		"health" : 10.0,
		"speed" : 0.6,
		"drop_price" : 700.0,
		"offset" : Vector2(241, 41),
	}
	
}


#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
