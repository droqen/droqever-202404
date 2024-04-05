extends KinematicBody2D

var _bank : NavdiBanker
var velocity : Vector2
var life : int = 100

func setup(bank, pos, dir):
	# hide for a few frames?
	_bank = bank
	velocity = dir * 2.0 # speed of shot?
	position = pos + velocity
	life = 60
	return self

func setup_mini(minang,maxang):
	$SheetSprite.setup([28])
	position += velocity.rotated(
		deg2rad(rand_range(minang,maxang))
	) * 2.5
	life = 30
	return self

func _physics_process(_delta):
	var hit = move_and_collide(velocity)
	if hit:
		if hit.collider.has_method("take_hit"):
			hit.collider.take_hit(self)
		queue_free()
	elif life > 0:
		life -= 1
		if life == 20:
			$SheetSprite.setup([28])
	else:
		queue_free()
