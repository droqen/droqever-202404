extends Node

var auto_held : bool = false
var player_held_and_idle : bool = false
var player_held_and_not_idle : bool = false
var hold : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_held_and_idle or auto_held:
		if hold > 0.9:
			hold += delta * 0.10
		elif player_held_and_idle:
			hold += delta
		else:
			hold += delta * 0.25
		if hold > 1.0:
			get_tree().call_group("stage", "reset_game")
#			get_tree().change_scene("res://InTheDatabaseXXI.tscn")
			hold = 0
	elif not player_held_and_not_idle:
		hold -= 3 * delta
		if hold < 0: hold = 0
	# else: hold += 0
