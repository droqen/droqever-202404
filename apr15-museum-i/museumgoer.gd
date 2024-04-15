extends NavdiMovingGuy

enum {
	STAND = 9291, AIR, DUCK, LIFTING, DROPPING, # movst
	LIFTBUF, DROPBUF,
	NOCARRY = 1242, CARRY,
}

onready var movst = TinyState.new(STAND, self, "_on_st_chg", true)
onready var carst = TinyState.new(NOCARRY, self, "_on_st_chg", true)
func _on_st_chg(_then,now):
	match [movst.id, carst.id]:
		[DUCK, _]: spr.setup([21])
		[LIFTING, _]: spr.setup([23])
		[DROPPING, _]: spr.setup([24])
		[_, NOCARRY]: spr.setup([20])
		[_, CARRY]: spr.setup([22])

func _ready():
	_on_st_chg(0, 0)

func _physics_process(_delta):
	bufs.process_bufs()
	var stick : Vector2
	var a = PinButton.new()
	if pin.pc:
		stick = pin.pc.stick.get_dpad_smoothed_vector()
		a = pin.pc.a
	accel_velocity(stick.x, 2.0, 0.05, 0.05)
	process_slidey_move()
	if a.pressed: bufs.on(JUMPBUF)
	
	if bufs.has(FLORBUF):
		if bufs.has(LIFTBUF):
			movst.goto(LIFTING)
		elif bufs.has(DROPBUF):
			movst.goto(DROPPING)
		elif stick.y > 0.5 and has_floor(): 
			movst.goto(DUCK)
		else:
			movst.goto(STAND)

func has_floor() -> bool:
	return $floor.get_overlapping_bodies()
