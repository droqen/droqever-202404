extends Node

onready var player = $"../easter"
onready var intro = $"../intro"
onready var intro2 = $"../intro2"
var waiting : float = 0.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.stick or not intro.is_done():
		waiting = 0.0
	else:
		waiting += delta
		if waiting > 5.0:
			intro.setup(intro2.bbcode_text)
#			intro.set_position_start()
#			intro.pause()
#			intro2.show()
#			intro2.resume_nodelay()
			queue_free()
