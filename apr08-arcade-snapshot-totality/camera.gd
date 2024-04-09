extends Camera2D

onready var follow_target = $"../land/trio"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tpx : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if tpx == 0:
		if follow_target.position.x < 32:
			tpx = -70
		if follow_target.position.x > 88:
			tpx = 70
	else:
		tpx = clamp(follow_target.position.x - 60, -70, 70)
		if follow_target.position.x > 32 and follow_target.position.x < 88:
			tpx = 0
	position.y = clamp(follow_target.position.y - 75, 0, 400)
	position += Vector2(tpx-position.x,0).limit_length(1)
	position.x = lerp(position.x, tpx, 0.1)
