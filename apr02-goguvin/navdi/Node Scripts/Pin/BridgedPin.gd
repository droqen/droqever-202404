extends Pin
class_name BridgedPin

onready var _jscb_get_joystick_update = JavaScript.create_callback(self, "_get_joystick_update")
var touch_stick : Vector2
var touch_stick_locked : float = 0.0
var touch_button_held: bool = false
var touch_button_tapped: bool = false
var touch_button_locked : float = 0.0
func _get_joystick_update(args):
	touch_stick = Vector2(args[0], args[1])
	if args[2]:
		touch_button_held = true
		touch_button_tapped = true
		touch_button_locked = 1.0 # don't respond to non touch controls for 1 second
	else:
		touch_button_held = false
	
	if touch_stick:
		stick = touch_stick
		touch_stick_locked = 10.0
	elif touch_stick_locked > 1.0:
		stick = touch_stick
		touch_stick_locked = 1.0

func _ready():
	print("Trying to connect to JS bridge . . ")
	var Bridge = JavaScript.get_interface("Bridge");
	if Bridge:
		Bridge.report_connection()
		prints("do i have a callback?", _jscb_get_joystick_update)
		Bridge.setup_joystick_if_mobile(_jscb_get_joystick_update)
		print("BRIDGE SUCCESS")
	else:
		print("No bridge (maybe you're not running on web?)")


func process_pins():
	stick = Vector2(
		Input.get_action_strength("E") - Input.get_action_strength("W"),
		Input.get_action_strength("S") - Input.get_action_strength("N")
	)
	if touch_stick_locked > 0:
		touch_stick_locked -= 0.0167
		if not stick: stick = touch_stick
	dpad = Vector2(
		(1 if Input.is_action_just_pressed("E") else 0)
		- (1 if Input.is_action_just_pressed("W") else 0),
		(1 if Input.is_action_just_pressed("S") else 0)
		- (1 if Input.is_action_just_pressed("N") else 0)
	)
	if touch_button_locked > 0:
		touch_button_locked -= 0.0167
		a.pressed = false
		a.released = false
		if a.held != (touch_button_held or touch_button_tapped):
			a.held = not a.held
			if a.held: a.pressed = true
			else: a.released = true
		touch_button_tapped = false
	else:
		for pb_pair in [[a,"A"],[b,"B"],[up,"N"],[down,"S"],[left,"W"],[right,"E"]]:
			var pb = pb_pair[0]
			pb.pressed = false
			pb.released = false
			if pb.held != (Input.get_action_strength(pb_pair[1]) > 0):
				pb.held = not pb.held
				if pb.held: pb.pressed = true
				else: pb.released = true
