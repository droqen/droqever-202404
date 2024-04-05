tool
extends MarchingTextContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	connect("char_marched", self, "_on_char_marched")

func _on_char_marched(c):
	$blip.pitch_scale=rand_range(0.5,1.0)
	$blip.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
