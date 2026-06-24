extends Node



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
