extends NavdiMovingGuy

enum { IDLE, MOVE, AIR, WALL, WALLBUF, WALLJUMPBUF }

var npc
signal npc_changed(npc)

onready var snailst = TinyState.new(IDLE,self,'_on_snailst_chg')
func _on_snailst_chg(_then,now):
	match now:
		IDLE:
			spr.setup([1])
		MOVE:
			spr.setup([4,1,5,1],len("snailst"))
		AIR:
			spr.setup([5])
		WALL:
			spr.setup([12, 13], 15)

func _ready():
	bufs.defons([[WALLBUF,10], [WALLJUMPBUF,10]])

func _physics_process(_delta):
	bufs.process_bufs()
	var pc = $Pin.pc
	var stick : Vector2
	var a : PinButton = PinButton.new()
	if pc:
		stick = pc.stick.get_dpad_smoothed_vector()
		a = pc.a
	accel_velocity(stick.x * 0.8, stick.y * 0.2 if bufs.has(WALLBUF) and stick.x else 2.0, 0.1, 0.1)
	if a.pressed: bufs.on(JUMPBUF)
	if bufs.try_consume([JUMPBUF, FLORBUF]): velocity.y = -1.5
	if bufs.try_consume([JUMPBUF, WALLJUMPBUF]):
		velocity.x = 0.5 if spr.flip_h else -0.5
		velocity.y = -1.0
		bufs.clr(WALLBUF)
	if stick.x:
		if stick.x < 0 != spr.flip_h:
			spr.flip_h = stick.x < 0
			bufs.clr(WALLBUF)
	
	process_slidey_move()
	
	var npc2 = null
	for body in $det_zone.get_overlapping_areas():
		if body.get('monologue'):
			npc2 = body
	if npc != npc2:
		if npc: npc.talk_off()
		npc = npc2
		if npc: npc.talk_on()
		emit_signal("npc_changed", npc)
	
	if bufs.has(WALLBUF):
		snailst.goto(WALL)
	elif bufs.has(FLORBUF):
		if stick.x:
			snailst.goto(MOVE)
		else:
			snailst.goto(IDLE)
	else:
		snailst.goto(AIR)

func on_bonk_h(hit:KinematicCollision2D):
	if velocity.x != 0 and (velocity.x < 0 == spr.flip_h):
		bufs.on(WALLBUF)
		bufs.on(WALLJUMPBUF)
	velocity.x = 0
func on_bonk_v(hit:KinematicCollision2D):
	if velocity.y >= 0:
		bufs.on(FLORBUF)
	velocity.y = 0
