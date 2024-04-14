extends NavdiMovingGuy

func _physics_process(_delta):
	bufs.process_bufs()
	var stick : Vector2
	var a = PinButton.new()
	if pin.pc:
		stick = pin.pc.stick.get_smooth_vector()
		a = pin.pc.a
	
	velocity += ((stick*1.1).limit_length(1) - velocity).limit_length(0.1)
	velocity *= 0.95
	process_slidey_move()
