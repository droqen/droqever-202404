extends NavdiMovingGuy

func _physics_process(_delta):
	$BridgedPin.process_pins()
	position += $BridgedPin.stick

