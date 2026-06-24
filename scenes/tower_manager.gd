extends Node2D
class_name TowerManager

@onready var placeable: Node2D = $Placeable
var all_areas: Array[Area2D] = []
var all_towers: Array[Tower] = []

func _ready() -> void:
	Global.tower_selected.connect(_on_tower_selected)
	Global.tower_manager = self
	self.tree_exiting.connect(func():
		Global.tower_manager = null
	)
	for child in placeable.get_children():
		var area = child as Area2D
		if not area: continue
		all_areas.append(area)

func place_tower(tower:Tower):
	if tower.placeable:
		tower.placed = true
		tower.freeze = true
		Global.clear_selected_tower()
	else:
		push_warning("Tower not placeable!! notif todo")

func _on_tower_selected(new_tower:Tower, type:Global.SelectionType):
	if type == Global.SelectionType.SPAWN:
		add_child(new_tower)
		new_tower.global_position = get_global_mouse_position()
		register_tower(new_tower)

func _process(delta: float) -> void:
	if Global.selected_tower != null:
		var target = get_global_mouse_position()
		var pos = Global.selected_tower.global_position
		var dir = target - pos
		if dir.length() > 1:
			Global.selected_tower.apply_central_force(dir.normalized() * 1000 * sqrt(dir.length()))
		else:
			Global.selected_tower.global_position = lerp(pos, target, delta * 3)
	if Input.is_action_just_pressed("l_click") and Global.selected_tower:
		self.place_tower(Global.selected_tower)

func register_tower(tower:Tower):
	if all_towers.find(tower) >= 0: return
	all_towers.append(tower)
	tower.register_areas(all_areas)
	tower.tree_exiting.connect(_deregister_tower.bind(tower))

func _deregister_tower(tower:Tower):
	if all_towers.find(tower) >= 0:
		all_towers.erase(tower)
