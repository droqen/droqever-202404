extends Camera2D

onready var snail = $"../world/snail"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if is_instance_valid(snail):
		position.x = floor(snail.position.x / 90) * 90
