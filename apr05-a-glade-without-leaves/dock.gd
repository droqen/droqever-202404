extends Node

onready var maze = $"../maze"
onready var intro = $"../intro"
onready var player = $"../easter"

var f : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	f += delta
	if f >= 1.0:
		f = 0.0
		var all38s = maze.get_used_cells_by_id(38)
		var all39s = maze.get_used_cells_by_id(39)
		for cell in all38s: maze.set_cellv(cell, 39)
		for cell in all39s: maze.set_cellv(cell, 38)
		if intro.is_done():
			if player:
				$"../erase".play()
				player.queue_free()
				player = null
