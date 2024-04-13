extends Node

export var change_one_in : int = 59
export var lines : PoolStringArray

# Called when the node enters the scene tree for the first time.
func _ready():
		get_parent().text = lines[randi()%len(lines)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if randi() % change_one_in == 0:
		get_parent().text = lines[randi()%len(lines)]
