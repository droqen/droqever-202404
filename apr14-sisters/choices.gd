extends Node2D

signal choose(choicedir)

var target : Vector2
var lunge : Vector2
onready var arrow = $choice_arrow
onready var arrowSprite = $choice_arrow/SheetSprite
onready var positions = $positions
onready var curst = TinyState.new(0, self, "_on_curst_chg")
func _on_curst_chg(_then,now):
	target = positions.get_child(now+1).position
	match now:
		-1, 1:
			arrowSprite.setup([60])
		0:
			arrowSprite.setup([61])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var pc = $Pin.pc
	if pc.stick.left.pressed: try_curst_goto(-1)
	if pc.stick.right.pressed: try_curst_goto(1)
	arrow.position = lerp(arrow.position, target + lunge, 0.35)
	lunge *= 0.8
	if pc.a.pressed and curst.id != 0:
		emit_signal("choose", curst.id)

func is_curst_valid(id) -> bool:
	match id:
		-1: return $left.text != ""
		1: return $right.text != ""
	return false

func try_curst_goto(id) -> bool:
	if is_curst_valid(id) and id != curst.id:
		curst.goto(id)
		return true
	else:
		lunge = Vector2(id * 20, 0)
		return false
