extends Node2D

signal request_influence_scale(dir)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var bank = $bank
	for cell in $maze.get_used_cells_by_id(2):
		$maze.set_cellv(cell,-1)
		bank.spawn("flipcoin",-1,$maze.map_to_center(cell)).setup(self, false)
	for cell in $maze.get_used_cells_by_id(6):
		$maze.set_cellv(cell,-1)
		bank.spawn("flipcoin",-1,$maze.map_to_center(cell)).setup(self, true)

func _on_flipcoin_collected(blk):
	emit_signal("request_influence_scale", 1 if blk else -1)
