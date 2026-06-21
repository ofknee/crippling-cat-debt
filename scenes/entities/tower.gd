extends RigidBody2D
class_name Tower
const BULLET = preload("res://scenes/entities/bullet.tscn")

var placeable := false
var placed := false
@onready var sprite: Sprite2D = $Sprite2D
var enemies_in_range: Array[Enemy] = []
var INFO = TowerInfo.stats
var type : TowerInfo.TowerType = TowerInfo.TowerType.LOW
var cumulative_timer := 0.0

func _ready() -> void:
	self.lock_rotation = true
func _get_stats() -> Dictionary:
	return INFO.get(type)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 40, Color.AQUAMARINE)

func _process(delta: float) -> void:
	_update_range()
	if not placed:
		if self.placeable: sprite.modulate.a = 1.0
		else: sprite.modulate.a = 0.7
	else:
		var stats = _get_stats()
		var cooldown = stats["attack_cooldown"]
		if not cooldown: push_error("Attack cooldown doesn't exist in tower type")
		if enemies_in_range.size() > 0 and enemies_in_range[0]:
			cumulative_timer += delta
			while cumulative_timer > cooldown:
				cumulative_timer -= cooldown
				var inst = BULLET.instantiate() as Bullet
				add_child(inst)
				inst.bullet_init(
					enemies_in_range[0], 
					stats["bullet_speed"], 
					stats["damage"]
				)
		else:
			#cumulative_timer = 0.0
			pass

func _update_range() -> void:
	enemies_in_range.clear()
	if Global.all_enemies.size() == 0:
		return
	var stats = _get_stats()
	var range: float = stats["range"]
	for e in Global.all_enemies:
		if e.global_position.distance_to(self.global_position) <= range:
			if enemies_in_range.find(e) != -1: continue
			enemies_in_range.append(e)

func register_areas(arr:Array[Area2D]):
	for area in arr:
		area.body_entered.connect(func(body:Node2D):
			if body == self:
				print("not Placeable")
				placeable = false
		)
		area.body_exited.connect(func(body:Node2D):
			if body == self:
				print("placeable")
				placeable = true
		)
