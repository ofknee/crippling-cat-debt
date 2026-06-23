extends RichTextLabel
@onready var wheel_button: PayButton = $".."

func _ready() -> void:
	wheel_button.price_changed.connect(func(new_price:int):
		self.text = "[font top=-40 bt=-5]WHEEL\n[font top=-30 bt=-5]" + \
			"[font_size=50]COSTS r%s" % new_price
	)
