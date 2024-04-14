extends Node2D

onready var player = $player
onready var camera = $camera
onready var original_text = $camera/Label.text

var rx : int = 0
var ry : int = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var nrx = floor(player.position.x/180)
	var nry = floor(player.position.y/180)
	if nrx!=rx or nry!=ry:
		rx = nrx
		ry = nry
		camera.position.x = 180 * rx
		camera.position.y = 180 * ry
		match [rx,ry]:
			[0,0]: $camera/Label.text = original_text
			_: if $camera/Label.text == original_text: $camera/Label.text = ""
