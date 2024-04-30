extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var l : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
#	$MarchingTextContainer/mcrtc/RichTextLabel.scroll_to_line(0)
	var lc = $m/mcrtc/RichTextLabel.get_line_count()
	var vlc = $m/mcrtc/RichTextLabel.get_visible_line_count()
	prints(lc,vlc)
	if vlc > 5:
		l += 1
		$m/mcrtc/RichTextLabel.scroll_to_line(l)
