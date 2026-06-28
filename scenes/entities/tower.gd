extends RigidBody2D
class_name Tower

const T = TowerInfoResource.TowerType
const BULLET = preload("res://scenes/entities/bullet.tscn")

#var INFO = TowerInfo.stats
var placeable := false
var placed := false
## bool for when popup is selecting the tower 
## becuase global somehow turns it to null in two frames >:(
var popupped := false
@export var range_color := Color(0.302, 0.651, 0.804, 0.349)
@export var range_color_error := Color(0.922, 0.431, 0.435, 0.337)
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var range_shown := false
var enemies_in_range: Array[Enemy] = []
var _stats : TowerInfoResource = null
var type : T = T.LOW :
	set(val):
		type = val
		_update_stats()
var cumulative_timer := 0.0
var level : int = 0
var t : Tween


func _ready() -> void:
	self.lock_rotation = true
	self.mouse_entered.connect(func(): 
		if not placed: return
		if t and t.is_running(): t.kill()
		t = create_tween().set_parallel(true)
		t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		t.tween_property(self, "modulate", Color.SKY_BLUE, 0.7)
	)
	self.mouse_exited.connect(func(): 
		if not placed: return
		if t and t.is_running(): t.kill()
		t = create_tween().set_parallel(true)
		t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		t.tween_property(self, "modulate", Color.WHITE, 0.7)
	)

func _update_stats():
	_stats = EntityDatabase.get_tower(self.type)

func get_stats() -> TowerInfoResource:
	return _stats

func _draw() -> void:
	#TODO tween the range radius :D
	if self.range_shown: 
		var col
		if not placed and placeable: col = range_color
		elif popupped or placed: col = range_color
		else: col = range_color_error
		draw_circle(Vector2.ZERO, _stats.range, col)
	#draw_circle(Vector2.ZERO, 40, Color.AQUAMARINE)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if Global.selected_tower and not Global.selected_tower.placed: return
	
	if event.is_action_pressed("l_click") and Input.is_action_just_pressed("l_click"):
		Global.select_tower(self, Global.SelectionType.INFO)
		print("Tower selected: %s" % Global.selected_tower)
		get_viewport().set_input_as_handled()



func _process(delta: float) -> void:
	self.input_pickable = self.placed
	
	
	_update_in_range()
	if not placed:
		self.range_shown = true
	else:
		self.range_shown = true \
			if Global.selected_tower == self \
			else false
		var cooldown = _stats.attack_cooldown
		if not cooldown: push_error("Attack cooldown doesn't exist in tower type")
		if enemies_in_range.size() > 0 and enemies_in_range[0]:
			cumulative_timer += delta
			while cumulative_timer > cooldown:
				cumulative_timer -= cooldown
				var inst = BULLET.instantiate() as Bullet
				add_child(inst)
				inst.bullet_init(
					enemies_in_range[0], 
					_stats.bullet_speed, 
					_stats.damage,
					cumulative_timer,
				)
		else:
			#cumulative_timer = 0.0
			pass
	sprite.animation = _stats.animation
	sprite.position = _stats.offset
	if not sprite.is_playing(): sprite.play(sprite.animation)
	queue_redraw()

func _update_in_range() -> void:
	enemies_in_range.clear()
	if Global.all_enemies.size() == 0:
		return
	var _range: float = _stats.range as float
	for e in Global.all_enemies:
		if e.global_position.distance_to(self.global_position) <= _range:
			if enemies_in_range.find(e) != -1: continue
			enemies_in_range.append(e)

func register_areas(arr:Array[Area2D]):
	for area in arr:
		area.body_entered.connect(func(body:Node2D):
			if body == self:
				placeable = false
		)
		area.body_exited.connect(func(body:Node2D):
			if body == self:
				placeable = true
		)
