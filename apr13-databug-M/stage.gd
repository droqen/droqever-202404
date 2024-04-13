extends Node2D

func reset_game():
	for child in get_children():
		child.queue_free()
	add_child(load("res://game.tscn").instance())
