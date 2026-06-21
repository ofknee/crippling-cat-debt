extends RigidBody2D
class_name Tower
const BULLET = preload("res://scenes/entities/bullet.tscn")

var placeable := false
var placed := false
@export var range_color := Color(0.302, 0.651, 0.804, 0.349)
@export var range_color_error := Color(0.922, 0.431, 0.435, 0.337)
var range_shown := false
var enemies_in_range: Array[Enemy] = []
var INFO = TowerInfo.stats
var type : TowerInfo.TowerType = TowerInfo.TowerType.LOW
var cumulative_timer := 0.0
var level : int = 0

func _ready() -> void:
	self.lock_rotation = true

func _get_stats() -> Dictionary:
	return TowerInfo.get_level_stats(type, level)

func _draw() -> void:
	#TODO tween the range radius :D
	if self.range_shown: 
		var col
		if not placed and placeable: col = range_color
		else: col = range_color_error
		draw_circle(Vector2.ZERO, _get_stats()["range"], col)
	draw_circle(Vector2.ZERO, 40, Color.AQUAMARINE)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	#print(event.to_string())
	if event.is_action_pressed("l_click") and Input.is_action_just_pressed("l_click"):
		Global.select_tower(self, Global.SelectionType.INFO)
		print("YAYAYA SELECTED%s" % Global.selected_tower)
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		print("YAYAYA SELECTED%s" % Global.selected_tower)
		pass

func _process(delta: float) -> void:
	self.input_pickable = self.placed
	
	_update_in_range()
	if not placed:
		self.range_shown = true
	else:
		self.range_shown = true if Global.selected_tower == self else false
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
	queue_redraw()

func _update_in_range() -> void:
	enemies_in_range.clear()
	if Global.all_enemies.size() == 0:
		return
	var stats = _get_stats()
	var _range: float = stats["range"] as float
	for e in Global.all_enemies:
		if e.global_position.distance_to(self.global_position) <= _range:
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
