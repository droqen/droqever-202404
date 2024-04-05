extends NavdiMovingGuy

enum { LAND = 9992, WALL, HOVER, STUN }
enum { LEFT_WALBUF = 1209, RIGHT_WALBUF, SHOOTBUF, STUNBUF, INVINCBUF, HEADBONKBUF }
onready var movst = TinyState.new(HOVER, self, "_on_movst_chg",true)
onready var facest = TinyState.new(1, self, "_on_facest_chg",true)
onready var leftwallst = TinyState.new(false, self, "_on_leftwallst_chg",true)
onready var rightwallst = TinyState.new(false, self, "_on_rightwallst_chg",true)
onready var floorst = TinyState.new(false, self, "_on_floorst_chg",true)
var energy : int = 99
var damage : int = 0

func _ready():
	bufs.defons([[LEFT_WALBUF,10], [RIGHT_WALBUF,10], [SHOOTBUF,2],
	[STUNBUF,20], [INVINCBUF,40], [HEADBONKBUF,20]])

func _on_movst_chg(_then,now):
	match now:
		LAND: spr.setup([4,5],8)
		WALL: spr.setup([7,6],8)
		HOVER: spr.setup([2,3],8)
		STUN:
			spr.setup([2,0],2)
			bufs.setmin(STUNBUF, 30 + 5 * min(9,damage))
			bufs.setmin(INVINCBUF, 60 + 5 * damage)
func _on_facest_chg(_then,now):
	spr.flip_h = now < 0
func _on_leftwallst_chg(_then,onwall):
	if onwall:
		velocity.x = 0.0
		facest.goto(-1)
		movst.goto(WALL)
	else:
		if stick.x >= 0: velocity.x += 0.5
		refresh_movst()
func _on_rightwallst_chg(_then,onwall):
	if onwall:
		velocity.x = 0.0
		facest.goto(1)
		movst.goto(WALL)
	else:
		if stick.x <= 0: velocity.x -= 0.5
		refresh_movst()
func _on_floorst_chg(_then,onfloor):
	if onfloor:
		velocity.y = 0.0
		movst.goto(LAND)
	else:
		if stick.y <= 0: velocity.y -= 0.5
		refresh_movst()
func refresh_movst():
	if floorst.id:
		movst.goto(LAND)
	elif leftwallst.id:
		facest.goto(-1)
		movst.goto(WALL)
	elif rightwallst.id:
		facest.goto(1)
		movst.goto(WALL)
	else:
		movst.goto(HOVER)

var stick : Vector2

func _physics_process(_delta):
	
	bufs.process_bufs()
	
	stick = Vector2.ZERO
	var a : PinButton = PinButton.new()
	var pc : PinController = $Pin.pc
	if pc:
		stick = pc.stick.vector # get the raw vector
		a = pc.a
	
	if bufs.has(HEADBONKBUF): stick.y = max(stick.y, 0.25)
	
	if a.held: bufs.on(SHOOTBUF)
	
	if movst.id == STUN:
		accel_velocity(
			0.0,
			2.0,
			0.02,
			0.10
		)
		process_slidey_move()
		if not bufs.has(STUNBUF): movst.goto(HOVER)
	else:
		leftwallst.goto((stick.x <= 0 or velocity.x <= 0)
			and $left_wal.get_overlapping_bodies())
		rightwallst.goto((stick.x >= 0 or velocity.x >= 0)
			and $right_wal.get_overlapping_bodies())
		floorst.goto((stick.y >= 0 or velocity.y >= 0)
			and $flor.get_overlapping_bodies())
		
		var target_velocity = stick * 1.0
		var accel = 0.1
		if energy > 99:
			target_velocity *= 1.5
			accel *= 0.5 + 0.01 * energy
		else:
			target_velocity *= lerp(0.75, 1.25, inverse_lerp(0, 99, energy))
			accel *= 1.0
			target_velocity.y += lerp(
				0.50, 0.00, inverse_lerp(0, 99, energy))
		velocity *= 0.99 # mild friction
		velocity += (target_velocity - velocity).limit_length(accel)
		accel_velocity(
			target_velocity.x,
			target_velocity.y,
			0.1 if floorst.id else 0.0,
			0.1 if (leftwallst.id or rightwallst.id) else 0.0)
		process_slidey_move()
		
		match movst.id:
			LAND:
				if energy<200:energy+=20
				if stick.x:
					spr.setup([4,5],8)
					facest.goto(sign(stick.x))
				else: spr.setup([1])
			WALL:
				if energy<200:energy+=20
				if stick.y: spr.setup([7,6],8)
				else: spr.setup([6])
			HOVER:
				energy -= 1
				if energy > 99: spr.setup([2,3],5)
				else: spr.setup([2,3],13)
		
		# flickering.
		if bufs.has(INVINCBUF):
			if bufs.read(INVINCBUF) % 3 < 1: hide()
			else: show()
		else: show()
	
	for body in $hurtbox.get_overlapping_bodies():
		if body != self:
			hit_by_enemy(body)

func on_bonk_h(hit:KinematicCollision2D):
	velocity.x = 0
func on_bonk_v(hit:KinematicCollision2D):
	if velocity.y < 0:
		bufs.on(HEADBONKBUF)
#		movst.goto(STUN)
	velocity.y = 0
 
func hit_by_enemy(enemy):
	if not bufs.has(INVINCBUF):
		damage += 1
		movst.goto(STUN)
		velocity.x = lerp(velocity.x, (enemy.position - position).normalized().x * 2.5, 0.5)
