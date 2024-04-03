extends Camera2D

onready var snail = $"../snail"

var clampzero : bool = true
var snailvx_follower : float

func _physics_process(_delta):
	if snail.position.x < 0:
		clampzero = false
	snailvx_follower = lerp(snailvx_follower, snail.velocity.x, 0.1)
	var tx = snail.position.x + snailvx_follower * 70 - 130/2
	position.x = lerp(position.x,
		clamp(
			clamp(position.x, tx - 25, tx + 25),
			0 if clampzero else -245,
			546
		),
		0.02)
