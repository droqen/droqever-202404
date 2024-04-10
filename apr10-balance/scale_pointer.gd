extends Node2D

const CENTERX = 55

export var steps_per_pixel : int = 60

var subpos : int = 0
var velocity : int = 0
var warning_flash : int = 0
onready var warning = $"../warning"

onready var spr = $SheetSprite

func get_balance() -> int: return int(sign(move_toward(position.x - CENTERX, 0, 5)))

func _physics_process(_delta):
	
	if abs(position.x-CENTERX) > 35 and (position.x-CENTERX)*velocity > 0:
		warning_flash = (warning_flash + 1) % 10
		if warning_flash < 6:
			warning.show()
			if position.x-CENTERX < 0:
				warning.text = "TOO WHITE!!!"
			else:
				warning.text = "TOO BLACK!!!"
		else:
			warning.hide()
	else:
		warning.hide()
	
	var figured_velocity : int = velocity
	var faster : bool = false
	match get_balance():
		0: faster = true
		-1: faster = velocity > 0
		1: faster = velocity < 0
	if faster: figured_velocity += sign(figured_velocity)
	match figured_velocity:
		-2,-1,0,1,2:
			spr.setup([13])
		-3,3:
			spr.setup([14])
			spr.flip_h = figured_velocity < 0
		_:
			spr.setup([15])
			spr.flip_h = figured_velocity < 0
	if faster: figured_velocity += sign(figured_velocity)
	subpos += figured_velocity
	position.x = CENTERX + round(subpos * 1.0 / steps_per_pixel)

func add_velocity ( value : int ):
	velocity += value
	if abs(velocity) < 2:
		velocity = value * 2 # always tip over to the other side of the balance

func is_overloaded() -> bool:
	return abs(position.x - CENTERX) >= 55
