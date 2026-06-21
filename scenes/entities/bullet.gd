extends Area2D
class_name Bullet

var speed: float
var damage: float
var target: Enemy
var last_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.set_collision_mask_value(1, false)
	self.set_collision_mask_value(2, true)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 7., Color.BLACK, true)

func bullet_init(enemy:Enemy, spd:float, dmg:float, age:float):
	var pos = global_position
	speed = spd
	damage = dmg
	last_dir = enemy.global_position - self.global_position
	last_dir = last_dir.normalized()
	target = enemy
	await get_tree().process_frame
	self.top_level = true
	self.global_position = pos
	self.global_position += last_dir * speed * age * 30.0

func _physics_process(delta: float) -> void:
	if not speed or not damage: return
	if target:
		last_dir = (target.global_position - self.global_position).normalized()
	self.global_position += last_dir * speed * delta * 30

func _on_body_entered(body:Node2D): 
	var enemy = body as Enemy
	if not enemy: return
	enemy.damage(damage)
	self.queue_free()
