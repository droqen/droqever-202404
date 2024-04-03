extends Node
class_name PinController

export var droqever_bridged : bool = true
var droqever_input_locked : bool = false
var droqever_input_timer : float = 0.0
onready var _jscb_get_droqever_input_changed = JavaScript.create_callback(
	self, "_get_droqever_input_changed")

var pin_droqever = PinInputSource.new()
var pin_keyboard = PinInputSource.new()
var pin_gamepad = PinInputSource.new()
var pins = [pin_droqever, pin_keyboard, pin_gamepad]

const GAMEPAD_DEADZONE = 0.1

var stick : PinStick = PinStick.new()
var a : PinButton = PinButton.new()

func _ready():
	add_to_group("pincontroller")
	call_deferred("add_child", pin_droqever)
	call_deferred("add_child", pin_keyboard)
	call_deferred("add_child", pin_gamepad)
#	setup_action(DIR_N, [KEY_UP, KEY_W], [11], [1], [-1])
#	setup_action(DIR_S, [KEY_DOWN, KEY_S], [12], [1], [1])
#	setup_action(DIR_W, [KEY_LEFT, KEY_A], [13], [0], [-1])
#	setup_action(DIR_E, [KEY_RIGHT, KEY_D], [14], [0], [1])
#		# every face button is the "A" button
#	setup_action(BUT_A, [KEY_Z, KEY_X, KEY_SPACE, KEY_ENTER], [0, 1, 2, 3])
#	setup_action(BUT_A, [KEY_Z, KEY_SPACE, KEY_ENTER], [0, 2])
#	setup_action(BUT_B, [KEY_X, KEY_SHIFT], [1, 3])
#	setup_action("reset", [KEY_ESCAPE])

#func setup_action(action, _keys = [], _joy_buttons = [], _joy_axes = [], _joy_axis_polarities = []):
#	InputMap.add_action(action, DIR_DEADZONE)
#	for key in _keys:
#		var ie_key = InputEventKey.new()
#		ie_key.scancode = key
#		InputMap.action_add_event(action, ie_key)
#	for jb in _joy_buttons:
#		var ie_jb = InputEventJoypadButton.new()
#		ie_jb.button_index = jb
#		InputMap.action_add_event(action, ie_jb)
#	if len(_joy_axes) != len(_joy_axis_polarities):
#		push_error("PinSetup.gd - # of joy axes and their polarities are mismatched")
#	else: for i in range(len(_joy_axes)):
#		var ja = _joy_axes[i]
#		var jp = _joy_axis_polarities[i]
#		var ie_ja = InputEventJoypadMotion.new()
#		ie_ja.axis = ja
#		ie_ja.axis_value = jp
#		InputMap.action_add_event(action, ie_ja)

func _input(event):
	if event is InputEventKey:
		match event.scancode:
			KEY_RIGHT, KEY_D: pin_keyboard.stick.pin_dpad(Vector2.RIGHT, event.pressed)
			KEY_UP,    KEY_W: pin_keyboard.stick.pin_dpad(Vector2.UP,    event.pressed)
			KEY_LEFT,  KEY_A: pin_keyboard.stick.pin_dpad(Vector2.LEFT,  event.pressed)
			KEY_DOWN,  KEY_S: pin_keyboard.stick.pin_dpad(Vector2.DOWN,  event.pressed)
			KEY_Z, KEY_X, KEY_SPACE, KEY_ENTER: pin_keyboard.a.pin(event.pressed)
	if event is InputEventJoypadButton:
		match event.button_index:
			11: pin_gamepad.stick.pin_dpad(Vector2.UP,    event.pressed)
			12: pin_gamepad.stick.pin_dpad(Vector2.DOWN,  event.pressed)
			13: pin_gamepad.stick.pin_dpad(Vector2.LEFT,  event.pressed)
			14: pin_gamepad.stick.pin_dpad(Vector2.RIGHT, event.pressed)
			0, 1, 2, 3: pin_gamepad.a.pin(event.pressed)
	if event is InputEventJoypadMotion:
		match event.axis:
			0: pin_gamepad.stick.pin_axis(Vector2.RIGHT,  event.axis_value, GAMEPAD_DEADZONE)
			1: pin_gamepad.stick.pin_axis(Vector2.UP,     event.axis_value, GAMEPAD_DEADZONE)

func _get_droqever_input_changed(args):
	pin_droqever.stick.pin(Vector2(args[0], args[1]))
	pin_droqever.a.pin(args[2])

func _physics_process(_delta):
	# stick
	for pin in pins:
		if pin.stick.vector:
			stick = pin.stick
			break
	# "a" button
	for pin in pins:
		if pin.a.held:
			a = pin.a
			break
