extends Camera2D

onready var target = $"../world/balancer"

var rx : int = 0
var ry : int = 0
var vx : float = 0.0
var vy : float = 0.0

func _physics_process(delta):
	rx = int(floor(target.position.x/110))
	ry = int(floor(target.position.y/80))
	if rx < 0: rx = 0
	if ry < 0: ry = 0
	var rtx : float = rx * 110
	var rty : float = ry * 80
	if rx >= 5:
		rty = target.position.y - 45
	if rx >= 6:
		get_parent().ending()
	
	vx = approach_linmul(vx, clamp(rtx-position.x,-10,10), 0.2, 0.05, 0.1)
	vy = approach_linmul(vy, clamp(rty-position.y,-10,10), 0.2, 0.05, 0.1)
	position += Vector2(vx,vy)

func approach_linmul(a,b,linrate,mulrate,damp=0.00):
	return lerp(move_toward(a,b,linrate),b,mulrate)*(1-damp)
