extends PixelMenu

@onready var odds_text: RichTextLabel = $OddsValue
@export var odds: int = 0
var t: Tween

func _ready():
	odds_text.scale = Vector2.ONE
	odds_text.text = "0%"
	await get_tree().create_timer(1).timeout
	inc_odds(10)

func get_odds():
	return odds
	
func set_odds(amount: int):
	odds = amount
	odds_text.text = str(odds) + "%"

func inc_odds(amount: int):
	odds_text.scale = Vector2.ONE
	if t and t.running(): t.kill()
	t = default_tween()
	t.tween_property(odds_text, "scale", Vector2.ONE * 0.05, 0.2)
	t.tween_property(odds_text, "position", Vector2(1062, 593), 0.2)
	await t.finished
	t = default_tween()
	odds += amount
	odds_text.text = str(odds) + "%"
	t.tween_property(odds_text, "scale", Vector2.ONE, 0.2)
	t.tween_property(odds_text, "position", Vector2(1012, 543), 0.2)
	await t.finished
	
