extends RigidBody2D
class_name Tower

var placeable := false
var placed := false

func _ready() -> void:
	self.lock_rotation = true

func register_areas(arr:Array[Area2D]):
	for area in arr:
		area.body_entered.connect(func(body:Node2D):
			if body == self:
				print("Placeable")
				placeable = true
		)
		area.body_exited.connect(func(body:Node2D):
			if body == self:
				print("Not placeable")
				placeable = false
		)
