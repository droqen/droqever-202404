extends Area2D

signal collected(blk)

var t : float = 0.0
var blk : bool

func setup(world, _blk:bool):
	connect("collected", world, "_on_flipcoin_collected")
	blk = _blk
	if blk: $SheetSprite.setup([6])
	return self

func _ready():
	t = position.x / 20.0

func _physics_process(_delta):
	t += 0.03
	$SheetSprite.position.y = 1.25 * sin(t)
	if get_overlapping_bodies():
		emit_signal("collected", blk)
		queue_free()
