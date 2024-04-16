extends NavdiMovingGuy

onready var maze = $"../maze"

enum {
	STAND = 9291, AIR, DUCK, LIFTING, DROPPING, # movst
	LIFTBUF, DROPBUF,
	NOCARRY = 1242, CARRY,
}

onready var movst = TinyState.new(STAND, self, "_on_st_chg", true)
onready var carst = TinyState.new(NOCARRY, self, "_on_st_chg", true)
func _on_st_chg(then,now):
	match then:
		LIFTING: if is_on_floor(): block_liftunder()
		DROPPING: block_dropunder()
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
	match movst.id:
		DUCK: stick.x = 0
	accel_velocity(stick.x, 2.0, 0.05, 0.05)
	process_slidey_move()
	
	if bufs.has(FLORBUF):
		if bufs.has(LIFTBUF):
			movst.goto(LIFTING)
		elif bufs.has(DROPBUF):
			movst.goto(DROPPING)
		elif stick.y > 0.5 and has_floor(): 
			movst.goto(DUCK)
			snap_to_floor()
		else:
			movst.goto(STAND)
	else:
		movst.goto(AIR)
		bufs.clr(LIFTBUF)
		bufs.clr(DROPBUF)
	
	match [movst.id, carst.id]:
		[DUCK, _]:
			if a.pressed:
				movst.goto(LIFTING)
				bufs.setmin(LIFTBUF, 10)
		[AIR, CARRY]:
			if a.pressed: block_dropunder() # or try, anyway
		_:
			if a.pressed: bufs.on(JUMPBUF)
	if bufs.try_consume([JUMPBUF,FLORBUF]):
		movst.goto(AIR)
		velocity.y = -1.0

func has_floor() -> bool:
	return $floor.get_overlapping_bodies()
func snap_to_floor() -> bool:
	var cell = maze.world_to_map(position)
	var to_centerx = maze.map_to_center(cell).x - position.x
	var possible_xs = [cell.x]
	if to_centerx < -3.1: possible_xs.append([cell.x+1])
	if to_centerx >  3.1: possible_xs.append([cell.x-1])
	for x in possible_xs:
		if maze.get_cellvalue_flag(maze.get_cell(x, cell.y)) != 1:
			if maze.get_cellvalue_flag(maze.get_cell(x, cell.y+1)) == 1:
				position.x = maze.map_to_center(Vector2(x, cell.y)).x
				velocity.x = 0
				return true
	return false # failed to snap to floor.

func block_liftunder():
	pass
func block_dropunder():
	pass
func refresh_carried():
	pass
