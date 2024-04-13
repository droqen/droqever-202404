extends NavdiMovingGuy

enum { IDLE=55595, WALK, ATTACK, ATTACKBUF, SHOWHPBUF, INVINCBUF }

onready var movst = TinyState.new(IDLE, self, "_on_movst_chg")

onready var bank = get_tree().get_nodes_in_group("worldbank")[0]

onready var maze = $"../maze"

var cant_go_left : bool = true
var cant_go_right : bool = false

var hp : int = 2

func _ready():
	bufs.defons([[SHOWHPBUF,60]])
	bufs.on(SHOWHPBUF)

func _on_movst_chg(_then,now):
	match now:
		IDLE: spr.setup([2])
		WALK: spr.setup([3,2],15)
		ATTACK: spr.setup([3])

func _physics_process(_delta):
	match bufs.read(SHOWHPBUF):
		0,2,3,5,6,7,10,11,12,13: $hp.hide()
		_:
			if bufs.read(SHOWHPBUF) % 8 < 2:
				$hp.hide()
			else:
				$hp.show()
	var pc = pin.pc
	var stick : Vector2
	var a = PinButton.new()
	if pc:
		stick = pc.stick.get_dpad_smoothed_vector()
		a = pc.a
	if cant_go_left and position.x <3: stick.x = 1
	if cant_go_right and position.x >=130-3: stick.x = -1
	bufs.process_bufs()
	if hp <= 0 and not $hurt.playing:
		queue_free() # oof.
	if movst.id == ATTACK and bufs.has(ATTACKBUF): stick = Vector2.ZERO
	accel_velocity(stick.x * 0.5, 0.0, 0.1, 99)
	process_slidey_move()
	
	if stick.x: spr.flip_h = stick.x < 0
	
	if a.pressed and not bufs.has(ATTACKBUF):
		bufs.setmin(ATTACKBUF, 30)
		var slash = bank.spawn("slash",-1,position)
		slash.setup(spr.flip_h)
		var slash_cell = maze.world_to_map(slash.position)
		if maze.get_cellv(slash_cell) == 30:
			maze.set_cellv(slash_cell, 32)
	
	if bufs.has(ATTACKBUF):
		movst.goto(ATTACK)
	elif stick.x:
		movst.goto(WALK)
	else:
		movst.goto(IDLE)

func take_damage(enemy):
	if not bufs.has(INVINCBUF):
		hp -= 1
		$hurt.play()
		if enemy.position.x > position.x:
			velocity.x = -2.0
		else:
			velocity.x = 2.0
		bufs.setmin(INVINCBUF, 60)
		bufs.on(SHOWHPBUF)
		$hp.setup([6+hp])
