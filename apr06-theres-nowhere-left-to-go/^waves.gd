extends Node

var wave : int = 14
var to_move_wave : int = 100
func _physics_process(_delta):
	to_move_wave -= 1
	if to_move_wave <= 0:
		to_move_wave = 100 + randi() % 20
		var next_wave : int = 15 if wave == 14 else 14
		for cell in get_parent().get_used_cells_by_id(wave):
			get_parent().set_cellv(cell, next_wave)
		wave = next_wave
