extends Node
class_name EnemyInfo

## strength is hwo much it affects odds once hit home base
static var stats := {
	
	"fly" : {
		"strength" : 1.0,
		"health" : 1.0,
		"drop_price" : 1000.0,
		"offset" : Vector2.ZERO
	},
	
	"beetle" : {
		"strength" : 2.0,
		"health" : 2.0,
		"drop_price" : 3000.0,
		"offset" : Vector2.ZERO
	},
	
	"blob" : {
		"strength" : 4.0,
		"health" : 5.0,
		"drop_price" : 10000.0,
		"offset" : Vector2.ZERO
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
