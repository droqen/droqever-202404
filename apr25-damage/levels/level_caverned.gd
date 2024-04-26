extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if $weirdfrog.dead:
		$unlock_node.reveal()
