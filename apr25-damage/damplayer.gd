extends NavdiMovingGuy

onready var bank = $"../../../bank"

enum { STILL, WALK, AIR }
onready var movst = TinyState.new( STILL, self, "_on_movst_chg")
var airjumps : int = 3
func _on_movst_chg(_then,now):
	match now:
		STILL: spr.setup([1,2,1,1],13)
		WALK:
			if spr.frame == 4:
				spr.setup([2,3,2,4],8)
			else:
				spr.setup([4,2,3,2],8)
		AIR:
			spr.setup([3])

func _physics_process(_delta):
	bufs.process_bufs()
	var stick : Vector2
	var a = PinButton.new()
	if pin and pin.pc:
		stick = pin.pc.stick.get_dpad_smoothed_vector()
		a = pin.pc.a
	accel_velocity(stick.x, 2.0, 0.02 + 0.05 * airjumps, 0.07)
	if a.pressed:
		if movst.id == AIR and airjumps > 0:
			airjumps -= 1
			if velocity.y > -1.2:
				velocity.y = -1.2
			spr.setup([4])
			bank.spawn("laserdown", -1, position)
		else:
			bufs.on(JUMPBUF)
	if bufs.try_consume([JUMPBUF,FLORBUF]):
		airjumps = 3
		velocity.y = -2.0
	if stick.x:
		spr.flip_h = stick.x < 0
	if bufs.has(FLORBUF):
		airjumps = 3
		if stick.x: movst.goto(WALK)
		else: movst.goto(STILL)
	else:
		movst.goto(AIR)
	process_slidey_move()
