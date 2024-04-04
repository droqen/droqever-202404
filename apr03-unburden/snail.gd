extends NavdiMovingGuy

enum { IDLE=11111, WALK, AIR, LAND, GROUND_INTERACT }
enum { CAR=58988, NOCAR }
enum { LANDBUF=12020, FLOATBUF }

func _ready():
	bufs.defons([[LANDBUF,5],[FLOATBUF,50]])
	respawn()

var ducking : bool = false

onready var startpos = position
onready var maze = $"../maze"

onready var movst = TinyState.new(IDLE,self,"_on_movst_or_carst_change",true)
onready var carst = TinyState.new(CAR,self,"_on_movst_or_carst_change",true)

func _on_movst_or_carst_change(then,now):
	match [then,now]:
		[AIR, LAND]: velocity.x *= 0.5
	
	match [movst.id,carst.id]:
		[IDLE,CAR]: spr.setup([63])
		[IDLE,NOCAR]: spr.setup([53])
		[WALK,CAR]: spr.setup([64,63,65,63],10)
		[WALK,NOCAR]: spr.setup([54,53,55,53],8)
		[AIR,CAR]: spr.setup([66])
		[AIR,NOCAR]: spr.setup([56])
		[LAND,CAR]:
			spr.setup([67])
			bufs.on(LANDBUF)
		[LAND,NOCAR]:
#			spr.setup([67])
			bufs.clr(LANDBUF)
		[GROUND_INTERACT,CAR]: spr.setup([67])
		[GROUND_INTERACT,NOCAR]: spr.setup([57])

func _physics_process(_delta):
	if position.x > 0 and position.y > 180:
		respawn()
#		carst.goto(NOCAR)
	
	# grab some inputs
	var stick : Vector2
	var a : PinButton = PinButton.new() # blank pinbutton
	if pin.pc:
		stick = pin.pc.stick.get_dpad_smoothed_vector()
		a = pin.pc.a # aheld, apressed
	if ducking or stick.y > 0: stick.x = 0.0
	if position.x < -245: stick.x = -1
	if position.x > 675: stick.x = 1
	
	bufs.process_bufs()
	if ducking:
		bufs.clr(JUMPBUF)
		if a.pressed:
			var cell = maze.world_to_map(position)
			var cell_below = maze.world_to_map(position + Vector2(0,7.5))
			var cellvalue_below = maze.get_cellv(cell_below)
				
			if carst.id == CAR:
				if maze.get_cellvalue_flag(cellvalue_below)==1:
					movst.goto(LAND)
					# put it down i guess
					carst.goto(NOCAR)
					position.y -= 10
					maze.set_cellv(cell, 12)
			else:
				if cellvalue_below==12:
					maze.set_cellv(cell_below, -1)
					position.y += 5
					velocity.y = 2.0
					# pick it up
					carst.goto(CAR)
	else:
		if a.pressed: bufs.on(JUMPBUF)
	
	
	var spd = 1.1
	if carst.id == CAR: spd *= 0.9
	if movst.id == LAND: spd *= 0.5
	var xaccel = 0.1
	if bufs.has(FLOATBUF) and movst.id == AIR: xaccel = 0.02
	accel_velocity(stick.x * spd, 2.0, xaccel, 0.12 if velocity.y < 0 and not a.held and carst.id == NOCAR else 0.05)
	if bufs.try_consume([JUMPBUF,FLORBUF]):
		velocity.y = -1.2 if carst.id == CAR else -1.5
	process_slidey_move()
	
	if stick.y > 0 and bufs.has(FLORBUF) and velocity.y >= 0:
		ducking = true
		var cell = maze.world_to_map(position)
		position.x = lerp(position.x, maze.map_to_world(cell).x + 5, 0.5)
	elif ducking:
		ducking = false
	
	if not bufs.has(FLORBUF):
		movst.goto(AIR)
	elif ducking:
		movst.goto(GROUND_INTERACT)
	elif movst.id == AIR or bufs.has(LANDBUF):
		movst.goto(LAND)
	elif stick.x:
		movst.goto(WALK)
	else:
		movst.goto(IDLE)
	
	if stick.x: spr.flip_h = stick.x < 0

func respawn():
	position = startpos
	velocity = Vector2(0.8,0)
	movst.goto(AIR)
	bufs.on(FLOATBUF)
