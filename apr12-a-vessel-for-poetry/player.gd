extends NavdiMovingGuy

enum { IDLE=55595, WALK, ATTACK, ATTACKBUF, }

onready var movst = TinyState.new(IDLE, self, "_on_movst_Chg")

onready var bank = $"../../bank"

func _on_movst_Chg(_then,now):
	match now:
		IDLE: spr.setup([2])
		WALK: spr.setup([3,2],15)
		ATTACK: spr.setup([3])

func _physics_process(_delta):
	var pc = pin.pc
	var stick : Vector2
	var a = PinButton.new()
	if pc:
		stick = pc.stick.get_dpad_smoothed_vector()
		a = pc.a
	if position.x < 3:
		stick.x = 1
	bufs.process_bufs()
	if movst.id == ATTACK and bufs.has(ATTACKBUF): stick = Vector2.ZERO
	accel_velocity(stick.x * 0.5, 0.0, 0.1, 99)
	process_slidey_move()
	
#	if stick.x: spr.flip_h = stick.x < 0
	
	if a.pressed and not bufs.has(ATTACKBUF):
		bufs.setmin(ATTACKBUF, 30)
		bank.spawn("slash",-1,position).setup(spr.flip_h)
	
	if bufs.has(ATTACKBUF):
		movst.goto(ATTACK)
	elif stick.x:
		movst.goto(WALK)
	else:
		movst.goto(IDLE)
