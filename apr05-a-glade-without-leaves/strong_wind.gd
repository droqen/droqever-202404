extends Node
onready var player = $"../easter"
onready var intro = $"../intro"
onready var particles = $"../CPUParticles2D"
var gust : float = 0.0
export var direction : int = -1
export var dies_out_after_intro : bool = false
func _physics_process(_delta):
	if randf() < 0.03:
		gust = randf()
	if gust > 0:
		var wind_strength = gust
		if direction < 0:
			if player.position.x < 10.0:
				wind_strength *= max(0, player.position.x / 10.0)
		if direction > 0:
			if 180 - player.position.x > 10.0:
				wind_strength *= max(0, (180 - player.position.x) / 10.0)
		player.velocity.x += 0.1 * direction + wind_strength * 0.15
		gust *= 0.95
		gust -= 0.01
	if dies_out_after_intro and intro.is_done():
		particles.emitting = false
		intro.setup("Suddenly the wind died.")
		queue_free()
