extends Node2D

var continuing : bool = false
var flicker : int = 0

func select_continue():
	continuing = true

func _physics_process(_delta):
	if continuing:
		flicker += 1
		if flicker % 10 < 5:
			$CenterContainer/VBoxContainer/Label2.modulate = Color.black
			$cursor.hide()
		else:
			$CenterContainer/VBoxContainer/Label2.modulate = Color.white
			$cursor.show()
		if flicker > 50:
			var stage = get_parent()
			stage.stagest.goto(stage.NAV)
