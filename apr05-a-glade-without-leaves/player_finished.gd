extends Area2D

onready var maze = $"../maze"
onready var intro = $"../intro"
onready var tree_text = $"../tree_text"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for player in get_overlapping_bodies():
		for cell in maze.get_used_cells_by_id(11):
			if cell.y >= 11: maze.set_cellv(cell, -1)
		intro.setup(tree_text.bbcode_text)
#		tree_text.resume_nodelay()
		queue_free()
#		player.emit_signal("exited_stage_right")
