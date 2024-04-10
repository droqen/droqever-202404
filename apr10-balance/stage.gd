extends Node2D

var game : bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if game:
		$world/balancer.blkst.goto($cam/scales/pointer.get_balance())
		if $cam/scales/pointer.is_overloaded():
			reset()

func _on_world_request_influence_scale(dir):
	$cam/scales/pointer.add_velocity(dir)

func reset():
	get_parent().add_child(load(self.filename).instance())
	queue_free()

func ending():
	game = false
	$world.queue_free()
	$cam.queue_free()
	$Label.show()
