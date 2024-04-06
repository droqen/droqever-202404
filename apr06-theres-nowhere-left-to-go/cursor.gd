extends Node2D


var t : float = 0.0
onready var startpos = position
var push : Vector2

var continuing : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if continuing:
#		push.x += delta
		position += push
	else:
		var pc = $Pin.pc
		if pc:
			if pc.stick.up.pressed:
				position = lerp(position, startpos, 0.5)
				push = Vector2(-2,-2)
			if pc.stick.down.pressed:
				position = lerp(position, startpos, 0.5)
				push = Vector2(0,2)
			if pc.a.pressed:
				get_parent().select_continue()
				continuing = true
				push.x = 0
				push.y = 0
				return # x out of that
		t += delta * 3.0
		$label_offset.position.x = sin(t)
		position += push
		push = lerp(push, startpos - position, 0.1)
		push *= 0.9
		if position.y < startpos.y - 2:
			modulate = Color(.4, .4, .4)
		else:
			modulate = Color.white

	
