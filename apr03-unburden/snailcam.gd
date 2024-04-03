extends Camera2D

onready var snail = $"../snail"

var snailvx_follower : float

func _physics_process(_delta):
	snailvx_follower = lerp(snailvx_follower, snail.velocity.x, 0.1)
	var tx = snail.position.x + snailvx_follower * 70 - 130/2
	position.x = lerp(position.x, max(0,clamp(position.x, tx - 25, tx + 25)), 0.02)
