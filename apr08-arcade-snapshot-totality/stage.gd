extends Node2D

const SUNS = [35,36,37,38,39,49]

onready var land_maze : NavdiMazeMaster = $land/maze
onready var land_maze_rect = land_maze.get_used_rect()
onready var sky_maze : NavdiMazeMaster = $camera/sky/maze
onready var sky_maze_rect = sky_maze.get_used_rect()
export var sun_cell : Vector2 = Vector2(9, 1)

var sun_progress : int = 0

func _ready():
	$land/trio.connect("found_npc", self, "_on_trio_found_npc")
	$land/trio.connect("lost_npc", self, "_on_trio_lost_npc")

var current_npc_says : String
var msg_retreating : bool = true

func _on_trio_found_npc(npc_says):
	print("Found " + npc_says)
	if npc_says:
		if current_npc_says != npc_says:
			current_npc_says = npc_says
			$camera/msg/MarginContainer/MarchingTextContainer.setup(npc_says)
		else:
			prints("resume? ",
				$camera/msg/MarginContainer/MarchingTextContainer.bbcode_text
			)
			$camera/msg/MarginContainer/MarchingTextContainer.resume_nodelay()
		$camera/msg.show()
		msg_retreating = false

func _on_trio_lost_npc():
	$camera/msg/MarginContainer/MarchingTextContainer.pause()
#	$camera/msg.hide()
	msg_retreating = true

func _physics_process(_delta):
	if $land/trio.position.y >= 524:
		queue_free()
		$"../black".call_deferred('show')
	
	sun_progress += 1
	set_sun_prog(floor(sun_progress/450))
	
	if msg_retreating:
		var mtc = $camera/msg/MarginContainer/MarchingTextContainer
		for i in range(3):
			if mtc.try_unmarch(): continue
			else:
				$camera/msg.hide()
				msg_retreating = false

func set_sun_prog(i):
	$land/trio.phase = i
	if i == 5:
		go_dark()
		sky_maze.set_cellv(sun_cell, 49)
	else:
		go_light()
		if i < 5:
			sky_maze.set_cellv(sun_cell, SUNS[i])
		else:
			sky_maze.set_cellv(sun_cell, SUNS[max(0,10-i)], true, true)
	
	for npc in $land.get_children():
		var phase_leaves = npc.get('phase_leaves')
		if phase_leaves and i >= phase_leaves:
			npc.queue_free()

func go_dark():
	for x in range(land_maze_rect.position.x, land_maze_rect.position.x + land_maze_rect.size.x):
		for y in range(land_maze_rect.position.y, land_maze_rect.position.y + land_maze_rect.size.y):
			match land_maze.get_cell(x, y):
				-1, 0: land_maze.set_cell(x, y, 10)
				1: land_maze.set_cell(x, y, 11)
	for x in range(sky_maze_rect.position.x, sky_maze_rect.position.x + sky_maze_rect.size.x):
		for y in range(sky_maze_rect.position.y, sky_maze_rect.position.y + sky_maze_rect.size.y):
			match sky_maze.get_cell(x, y):
				10: sky_maze.set_cell(x, y, 48)

func go_light():
	for x in range(land_maze_rect.position.x, land_maze_rect.position.x + land_maze_rect.size.x):
		for y in range(land_maze_rect.position.y, land_maze_rect.position.y + land_maze_rect.size.y):
			match land_maze.get_cell(x, y):
				10: land_maze.set_cell(x, y, -1)
				11: land_maze.set_cell(x, y, 1)
	for x in range(sky_maze_rect.position.x, sky_maze_rect.position.x + sky_maze_rect.size.x):
		for y in range(sky_maze_rect.position.y, sky_maze_rect.position.y + sky_maze_rect.size.y):
			match sky_maze.get_cell(x, y):
				48: sky_maze.set_cell(x, y, 10)
