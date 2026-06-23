extends RichTextLabel
@onready var odds_button: PayButton = $".."

func _ready() -> void:
	odds_button.price_changed.connect(func(new_price:int):
		self.text = "[font top=-40 bt=-5]k5i\n[font top=-30 bt=-5]" + \
			"[font_size=50]COSTS r%s" % new_price
	)
