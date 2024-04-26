extends Node2D

func _ready():
	hide()

func reveal():
	if not visible:
		show()
		for child in get_children():
			if child.has_method('reveal'):
				child.reveal()
