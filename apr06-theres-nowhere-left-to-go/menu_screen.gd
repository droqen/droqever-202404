extends Node2D

signal done
signal request_start_game_snd

var continuing : bool = false
var flicker : int = 0

func select_continue():
	if not continuing:
		continuing = true
		emit_signal("request_start_game_snd")
func _physics_process(_delta):
	if continuing:
		flicker += 1
		if flicker % 10 < 5:
			$CenterContainer/VBoxContainer/Label2.modulate = Color.black
			$cursor.hide()
		else:
			$CenterContainer/VBoxContainer/Label2.modulate = Color.white
			$cursor.show()
		if flicker > 100:
			emit_signal("done")
