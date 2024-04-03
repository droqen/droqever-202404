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

func pin_axis(axis : Vector2, v : float):
	if axis.x and not axis.y:
		vector.x = v
		left.pin(vector.x <= -TAPZONE)
		right.pin(vector.x >= TAPZONE)
	elif axis.y and not axis.x:
		vector.y = v
		up.pin(vector.y <= TAPZONE)
		down.pin(vector.y >= TAPZONE)
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

var deadzone : float = 0.0

func get_smooth_vector() -> Vector2:
	var raw_vector : Vector2 = vector
	var raw_amp : float = raw_vector.length()
	if raw_amp <= deadzone: return Vector2.ZERO
	var raw_dir : Vector2 = raw_vector.normalized()
	return raw_dir * lerp(0, 1, inverse_lerp(deadzone, TAPZONE, raw_amp))
