extends Node2D
class_name Enemy

@onready var health_component: HealthComponent = $HealthComponent

func damage(amount:float) -> void:
	var atk = Attack.new()
	atk.damage = amount
	health_component.damage(atk)
