extends NavdiMovingGuy

enum { CHARGING=737, HITTED, HITTEDBUF, INVINCBUF }

var hp : int = 3
var target : Node2D
onready var enemyst = TinyState.new(CHARGING, self, "_on_enemyst_chg")
onready var head_wobb : int = randi() % 4
var head_subwobb : int = 50

func _on_enemyst_chg(then,now):
	match then:
		HITTED:
			if hp <= 0:
				queue_free()
	
	match now:
		CHARGING:
			pass
		HITTED:
			bufs.setmin(HITTEDBUF, 15)
			bufs.setmin(INVINCBUF, 60)
			if is_instance_valid(target):
				velocity.x = -0.5 * sign(target.position.x-position.x)

func _ready():
	target = $"../../player"
	if position.x < target.position.x:
		spr.flip_h = true

func _physics_process(_delta):
	if head_subwobb > 0:
		head_subwobb -= 1
	else:
		head_wobb = (head_wobb + 1) % 4
		head_subwobb = 30 + randi() % 30
	$head.position.x = sin(PI*head_wobb*0.5)
	
	bufs.process_bufs()
	
	if enemyst.id == HITTED or not is_instance_valid(target):
		accel_velocity(0.0, 0.0, 0.05, 0.0)
	else:
		accel_velocity(0.25 * sign(target.position.x-position.x), 0.0, 0.1, 0.0)
	process_slidey_move()

	if not bufs.has(INVINCBUF):
		for area in $Area2D.get_overlapping_areas():
			if area.get('slashst'):
				enemyst.goto(HITTED) # ow
				hp -= 1
	if enemyst.id != HITTED:
		for body in $Area2D.get_overlapping_bodies():
			if body.has_method('take_damage'):
				body.take_damage(self)
				enemyst.goto(HITTED) # slight recoil
				bufs.clr(INVINCBUF)
			

	if bufs.has(HITTEDBUF):
		enemyst.goto(HITTED)
	else:
		enemyst.goto(CHARGING)
	
	if bufs.has(INVINCBUF):
		if bufs.read(INVINCBUF) % 8 < 4:
			hide()
		else:
			show()
	else:
		show()
