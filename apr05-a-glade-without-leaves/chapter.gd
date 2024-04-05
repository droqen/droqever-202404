extends Node2D

signal finished

func _ready():
	$easter.connect("exited_stage_right", self, "_on_easter_exited")

func _on_easter_exited():
	emit_signal("finished")
