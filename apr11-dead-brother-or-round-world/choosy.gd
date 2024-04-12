extends NavdiMovingGuy


enum{IDLE=299282,WALK,AIR,CLING,
	CLINGBUF}
onready var movst = TinyState.new(IDLE,self,"_on_movst_chg")
func _on_movst_chg(_then,now):
	match now:
		IDLE: spr.setup([31])
		WALK: spr.setup([32,31,33,31],4)
		AIR: spr.setup([33])
		CLING: spr.setup([34])
func _ready():
	bufs.defons([[CLINGBUF,4]])
func _physics_process(_delta):
	bufs.process_bufs()
	var pc = $Pin.pc
	var stick : Vector2
	var a = PinButton.new()
	if pc: 
		stick = pc.stick.get_dpad_smoothed_vector()
		a = pc.a
	if stick.x == 0 and movst.id == CLING:
		stick.x = -1 if spr.flip_h else 1
	if a.pressed: bufs.on(JUMPBUF)
	if bufs.try_consume([JUMPBUF,FLORBUF]):
		velocity.y = -2.0
	elif bufs.try_consume([JUMPBUF,CLINGBUF]):
		velocity.y = -1.5
	if bufs.has(CLINGBUF):
		accel_velocity(stick.x,0.0,0.1,0.1)
	else:
		accel_velocity(stick.x,3.0,0.1,0.1)
	process_slidey_move()

	if stick.x: spr.flip_h = stick.x < 0

	if bufs.has(CLINGBUF):
		movst.goto(CLING)
	elif bufs.has(FLORBUF):
		if stick.x:
			movst.goto(WALK)
		else:
			movst.goto(IDLE)
	else:
		movst.goto(AIR)

func on_bonk_h(hit:KinematicCollision2D):
	if velocity.x and velocity.y >= 0 and not bufs.has(FLORBUF):
		if velocity.x < 0 == spr.flip_h:
			bufs.on(CLINGBUF)
			movst.goto(CLING)
	velocity.x = 0
