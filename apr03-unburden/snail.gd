extends NavdiMovingGuy

enum { IDLE=11111, WALK, AIR, LAND }
enum { LANDBUF=12020 }

func _ready():
	bufs.defons([[LANDBUF,5]])

onready var movst = TinyState.new(IDLE,self,"_on_movst_change")

func _on_movst_change(then,now):
	match [then,now]:
		[AIR, LAND]: velocity.x *= 0.5
	match now:
		IDLE: spr.setup([63])
		WALK: spr.setup([64,63,65,63],8)
		AIR: spr.setup([66])
		LAND:
			spr.setup([67])
			bufs.on(LANDBUF)

func _physics_process(_delta):
	
	# grab some inputs
	var stick : Vector2
	var a : PinButton = PinButton.new() # blank pinbutton
	if pin.pc:
		stick = pin.pc.stick.get_smooth_vector()
		a = pin.pc.a # aheld, apressed
	
	bufs.process_bufs()
	if a.pressed: bufs.on(JUMPBUF)
	
	accel_velocity(stick.x * 1.0, 2.0, 0.1, 0.05)
	if bufs.try_consume([JUMPBUF,FLORBUF]):
		velocity.y = -1.2
	process_slidey_move()
	
	if not bufs.has(FLORBUF):
		movst.goto(AIR)
	elif movst.id == AIR or bufs.has(LANDBUF):
		movst.goto(LAND)
	elif stick.x:
		movst.goto(WALK)
	else:
		movst.goto(IDLE)
	
	if stick.x: spr.flip_h = stick.x < 0
