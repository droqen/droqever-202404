extends NavdiMazeNobody

var can_leave : bool = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var padrepeat : int = 0
var failedmove_dur : int = 0
var failedmove_dir : Vector2
var bumped : Node2D = null
var bumpbuf : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var maze = $"../maze"
	setup(maze, maze.world_to_map(position))

var dpad : Vector2

func _physics_process(_delta):
	var prev_dpad : Vector2 = dpad
	dpad = Vector2(0, 0)
	var pc = $Pin.pc
	if bumpbuf > 0 and bumpbuf < 99:
		bumpbuf -= 1
		if bumpbuf <= 0:
			bumped.post_bump()
			bumped = null
	elif pc.stick:
		dpad = pc.stick.get_dpad_vector()
	
	if (dpad.x and not prev_dpad.x) or (dpad.y and not prev_dpad.y):
		padrepeat = 0
	elif padrepeat > 0 and padrepeat < 99:
		padrepeat -= 1
	
	if dpad and padrepeat <= 0 and vector_to_center().length_squared() < 8:
		var moves = []
		if dpad.x: moves.append(Vector2(dpad.x, 0))
		if dpad.y: moves.append(Vector2(0, dpad.y))
		for move in moves:
			if try_move(move):
				padrepeat = 12
				failedmove_dur = 0
				break
		if padrepeat == 0: # i.e. if not moving
			for move in moves:
				if try_bump(move):
					if bumpbuf < 10: bumpbuf = 10
					failedmove_dir = move
					failedmove_dur = 5
					padrepeat = 99
					if bumpbuf < 99:
						$bump.pitch_scale = 1.2
						$bump.play()
					else:
						failedmove_dur = 10
					break
			if bumpbuf == 0: # i.e. no bump target found
				for move in moves:
					failedmove_dir = move
					failedmove_dur = 5
					padrepeat = 99
					$bump.pitch_scale = 1.0
					$bump.play()
					break
	
	if failedmove_dur > 0:
		position += failedmove_dir * 2
		failedmove_dur -= 1
		if failedmove_dur <= 0 and can_leave and bumpbuf >= 99:
			queue_free()
	var dx : int = vector_to_center().x
	var dy : int = vector_to_center().y
	position.x += sign(dx) * ceil(abs(dx)/10.0)
	position.y += sign(dy) * ceil(abs(dy)/10.0)
	
	if dx or dy:
		$SheetSprite.set_frame_period(15)
	else:
		$SheetSprite.set_frame_period(30)

func try_bump(move) -> bool:
	var bodies_at_destination = maze.get_bodies(_cell + move)
	for body in bodies_at_destination:
		if body.has_method('bump'):
			bumped = body
			bumpbuf = 10
			if can_leave:
				bumpbuf = 99
				return true # don't bump the other body
			body.bump(move)
			return true
	return false

func is_move_legal(_from, to) -> bool:
	return maze.get_cellvalue_flag(maze.get_cellv(to))!=1 and not maze.get_bodies(to)
	
