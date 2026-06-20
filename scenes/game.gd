extends PixelMenu
class_name Game

func start_anim(): 
	Global.state = Global.States.GAME

func end_anim(): self.hide()
