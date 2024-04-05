extends Camera2D

onready var moonmoth = $"../moonmoth"

func _physics_process(_delta):
	position.y = clamp(moonmoth.position.y - 90, -940, 0)
