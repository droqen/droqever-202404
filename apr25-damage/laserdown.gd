extends Area2D

var life : int = 30
var vy : float = -0.05
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	life -= 1
	if life < 20:
		$CollisionShape2D.disabled = true
		$vis.call('show' if life%2==0 else 'hide')
		$vis.scale.x = .01 * life + 0.25
	if life < 0:
		queue_free()
	position.y += vy
	vy -= 0.01
	
	for body in get_overlapping_bodies():
		if body.has_method("on_lasered"):
			body.call("on_lasered")
