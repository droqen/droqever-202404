extends NavdiMovingGuy

func _physics_process(_delta):
	var pc = pin.pc
	position += pc.stick.vector
	var spr = $Sprite
	if pc.stick.left.pressed:
		spr.flip_h = not spr.flip_h
	if pc.stick.right.pressed:
		spr.flip_h = not spr.flip_h
	if pc.a.pressed:
		spr.flip_h = not spr.flip_h
