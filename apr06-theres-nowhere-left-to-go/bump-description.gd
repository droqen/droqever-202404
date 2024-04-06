extends NavdiMazeNobody

export (String, MULTILINE) var description : String

func _ready():
	var maze = $"../maze"
	setup(maze, maze.world_to_map(position))

var bump_dir : Vector2
var bump_dur : int
var unseen : bool = true

func bump(dir : Vector2):
	bump_dir = dir
	bump_dur = 5
	unseen = false

func post_bump():
	get_parent().display_description(description)

func _physics_process(_delta):
	if bump_dur > 0:
		bump_dur -= 1
		position += bump_dir
	else:
		position += vector_to_center().limit_length()
