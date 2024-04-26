extends Node2D

export (String, FILE, "*.tscn") var first_level_path = "res://level1.tscn"

func _ready():
	load_target_level(first_level_path)
func load_target_level(target_level_path):
	for child in $levelMgr.get_children():
		child.queue_free()
	$levelMgr.add_child(load(target_level_path).instance())
	$Camera2D.position.y = -35
func load_level1():
	load_target_level("res://level1.tscn")
func load_next_level():
	load_level1()
func _physics_process(_delta):
	$Camera2D.position.y = move_toward($Camera2D.position.y, 0, 0.5)
