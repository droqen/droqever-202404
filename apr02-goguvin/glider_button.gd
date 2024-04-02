extends NavdiMovingGuy

func _physics_process(_delta):
	var pin = $BridgedPin
	pin.process_pins()
	bufs.process_bufs()
	accel_velocity(
		pin.stick.x * 1.5,
		2.5,
		0.15 if bufs.has(FLORBUF) else 0.05,
		0.015 if velocity.y > 0 or pin.a.held else 0.06
	)
	if pin.a.pressed: bufs.on(JUMPBUF)
	prints(bufs.read(JUMPBUF), bufs.read(FLORBUF))
	if bufs.try_consume([FLORBUF,JUMPBUF]): velocity.y = -1.5
	if pin.stick.x: spr.flip_h = pin.stick.x < 0
	process_slidey_move()
	position.x = fposmod(position.x, 200)
