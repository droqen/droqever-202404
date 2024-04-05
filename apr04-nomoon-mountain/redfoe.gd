extends NavdiMovingGuy

onready var player = $"../moonmoth"
var hp : int = 9
var charge : int = 0
enum {IDLE=231231, ANGRY, LUNGE}
enum {LUNGEBUF=444, HURTBUF}
var lunge_velocity : Vector2
onready var angst = TinyState.new(IDLE,self,"_on_angst_chg")
func _on_angst_chg(_then,now):
	match now:
		IDLE: spr.setup([31])
		ANGRY:
			charge = randi() % 80
			spr.setup([31])
		LUNGE:
			spr.setup([32])
			bufs.setmin(LUNGEBUF, 30)
			charge = 0

func _physics_process(_delta):
	bufs.process_bufs()
	match angst.id:
		IDLE:
			for body in $player_spot.get_overlapping_bodies():
				if body == player: anger()
				elif body != self and body.get('angst') and body.angst.id == ANGRY: anger()
		ANGRY:
			for body in $player_spot.get_overlapping_bodies():
				if body != self and body.get('angst'):
					# repel
					var away_from_body = position - body.position
					var away_from_body_l_sqr = max(10, away_from_body.length_squared())
					velocity += away_from_body.normalized() / away_from_body_l_sqr * 50
			var to_player = (player.position) - position
			var to_player_moving_target = to_player + player.velocity * (to_player.length() * 0.1)
			velocity += (to_player_moving_target.normalized() * 0.65 - velocity).limit_length(0.1)
			if charge < 99:
				charge += 1
			else:
				if to_player.length() < 100:
					lunge_velocity = to_player_moving_target.normalized() * 2.00
					velocity = lerp(velocity, lunge_velocity, 0.2) # lunge!!!
					angst.goto(LUNGE)
		LUNGE:
			velocity += (lunge_velocity - velocity).limit_length(0.2)
			if not bufs.has(LUNGEBUF):
				angst.goto(ANGRY)
	process_slidey_move()
	if bufs.has(HURTBUF):
		call("show" if bufs.read(HURTBUF) % 4 < 2 else "hide")
	elif hp <= 0:
		queue_free()
	else:
		show()

func take_hit(hitter : Node2D):
	if not bufs.has(HURTBUF):
		hp -= 1
		bufs.setmin(HURTBUF, 7)
		match angst.id:
			IDLE: anger()
			ANGRY: pass
			LUNGE: pass # ignore these hits

func anger():
	if angst.id == IDLE:
		angst.goto(ANGRY)
#		$player_spot.queue_free() # not necessary

func on_bonk_h(hit:KinematicCollision2D):
	if hit.get('life'): return # don't bounce off of bullets
	velocity.x *= -0.6
func on_bonk_v(hit:KinematicCollision2D):
	if hit.get('life'): return # don't bounce off of bullets
	velocity.y *= -0.6
 
