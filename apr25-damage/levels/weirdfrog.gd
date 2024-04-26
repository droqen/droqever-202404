extends NavdiMovingGuy

onready var player = $"../damplayer"

var dead : bool = false

func _physics_process(_delta):
	bufs.process_bufs()
	if dead:
		accel_velocity(0, 1, 0.05, 0.1)
	else:
		if player.position.x < position.x:
			spr.flip_h = false
		else:
			spr.flip_h = true
		var xaccel = 0.1 if bufs.has(FLORBUF) else 0.0
		accel_velocity(0, 1, xaccel, 0.03)
		if bufs.has(FLORBUF) and randf() < (0.003 if player.velocity.y >= 0 else 0.02):
			velocity.x = 1 if spr.flip_h else -1
			velocity.y = -1
	process_slidey_move()

func on_lasered():
	spr.setup([22])
	#splat.
	dead = true
