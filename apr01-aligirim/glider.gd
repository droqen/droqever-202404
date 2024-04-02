extends NavdiMovingGuy

func _physics_process(_delta):
	$BridgedPin.process_pins()
	position += $BridgedPin.stick
	
	position.x = fposmod(position.x, 200)
	position.y = fposmod(position.y, 130)

	if $BridgedPin.stick.x:
		spr.flip_h = $BridgedPin.stick.x < 0
