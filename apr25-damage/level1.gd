extends Node2D



func _on_level1_trigger_body_entered(body):
	$unlock_node.reveal()
