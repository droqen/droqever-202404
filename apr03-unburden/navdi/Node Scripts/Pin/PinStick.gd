class_name PinStick
extends Reference

const TAPZONE : float = 0.95

var vector : Vector2
# taps
var right : PinButton = PinButton.new()
var up : PinButton = PinButton.new()
var left : PinButton = PinButton.new()
var down : PinButton = PinButton.new()
var dpad = [right,up,left,down]

func pin(v : Vector2):
	pin_axis(Vector2.RIGHT, v.x)
	pin_axis(Vector2.DOWN, v.y)

func pin_axis(axis : Vector2, v : float, deadzone : float = 0.0):
	if deadzone > 0.0:
		if v > deadzone: v = lerp(0, 1, inverse_lerp(deadzone, TAPZONE, v))
		elif v < -deadzone: v = lerp(0, -1, inverse_lerp(-deadzone, -TAPZONE, v))
		else: v = 0
	
	if axis.x and not axis.y:
		vector.x = v
		left.pin(vector.x <= -1)
		right.pin(vector.x >= 1)
	elif axis.y and not axis.x:
		vector.y = v
		up.pin(vector.y <= 1)
		down.pin(vector.y >= 1)
	else:
		push_error("PinStick cannot handle bad pin axis "+str(axis))

func pin_dpad(dir : Vector2, held : bool):
	if dir.x and not dir.y:
		(right if dir.x>0 else left).pin(held)
		vector.x = (1 if right.held else 0) - (1 if left.held else 0)
	elif dir.y and not dir.x:
		(down if dir.y>0 else up).pin(held)
		vector.y = (1 if down.held else 0) - (1 if up.held else 0)
	else:
		push_error("PinStick cannot handle bad dpad dir "+str(dir))

func end_frame():
	for dir in dpad: dir.end_frame()

func clr():
	vector = Vector2.ZERO
	for dir in dpad: dir.clr()
