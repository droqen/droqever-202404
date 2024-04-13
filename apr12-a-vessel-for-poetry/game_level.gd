extends Node2D

signal win
signal lose

class_name GameLevel
export (String, FILE, "*.tscn") var next_level : String = ""
export var win_right_side : bool = true
export var go_right_req_no_enemies : bool = true
export var no_winning : bool = false
onready var player = $player
onready var enemies = $enemies

var enemy_count : int = -1

func _ready():
	$Label.hide()

func _physics_process(_delta):
	enemy_count = enemies.get_child_count()
	
	if enemy_count == 0:
		$Label.show()
	
	if is_instance_valid(player):
		player.cant_go_right = (enemy_count != 0) if (go_right_req_no_enemies) else (false)
		if win_right_side and player.position.x >= 133: emit_signal("win")
		if no_winning and player.position.x >= 133: player.queue_free()
	elif not no_winning:
		emit_signal("lose")
