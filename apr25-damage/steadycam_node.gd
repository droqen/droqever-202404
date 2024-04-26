extends Node2D

func _ready():
	hide()

func _physics_process(_delta):
	if not visible:
		var camera = get_tree().get_nodes_in_group("camera")[0]
		if camera.position.y == 0: show()
