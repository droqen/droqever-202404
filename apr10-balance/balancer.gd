extends NavdiMovingGuy

enum { IDLE = 999, WALK, AIR, }

onready var movst = TinyState.new(IDLE,self,"_on_movst_or_blkst_chg",true)
onready var blkst = TinyState.new(0,self,"_on_movst_or_blkst_chg",true)

func _ready():
	_on_movst_or_blkst_chg(0,0)

func _on_movst_or_blkst_chg(_then,now):
	var b : int = 00
	match blkst.id:
		-1: b = 00
		0: b = 10
		1: b = 20
	match movst.id:
		IDLE:
			spr.setup([20+b])
		WALK:
			spr.setup([21+b,20+b,22+b,20+b],7)
		AIR:
			spr.setup([22+b])

func _physics_process(_delta):
	var p = $Pin.pc
	var stick : Vector2
	var a = PinButton.new()
	if p:
		stick = p.stick.get_dpad_smoothed_vector()
		a = p.a
	
	bufs.process_bufs()
	if a.pressed: bufs.on(JUMPBUF)
	if stick.x: spr.flip_h = stick.x < 0
#	accel_velocity(stick.x, 2.0, 0.1, 0.12 if velocity.y<0 and not a.held else 0.05)
	if position.x > 550:
		accel_velocity(0.10, -0.05, 0.05, 0.01)
	else: match blkst.id:
		1: accel_velocity(stick.x * 0.75, 2.00, 0.05, 0.06)
		0: accel_velocity(stick.x * 0.50, 0.50, 1.00, 0.10)
		-1:accel_velocity(stick.x * 1.00, 2.00, 0.10, 0.10)
	if bufs.try_consume([JUMPBUF, FLORBUF]):
		velocity.y = -1.55
	process_slidey_move()
	
	if bufs.has(FLORBUF):
		if stick.x:
			movst.goto(WALK)
		else:
			movst.goto(IDLE)
	else:
		movst.goto(AIR)
