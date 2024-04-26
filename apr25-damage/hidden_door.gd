extends Sprite

onready var player = $"../../damplayer"

export (String, FILE, "*.tscn") var target_level_path = "res://level1.tscn"

func _ready():
	hide()

func reveal():
	show()
	$appear.play()
	$opening_eye.set_frame_index(0)

func _physics_process(_delta):
	if visible:
		if has_node('opening_eye'):
			if $opening_eye.frame == 28:
				$opening_eye.queue_free()
		elif is_instance_valid(player):
			if $trig_left.get_overlapping_bodies() and $trig_right.get_overlapping_bodies():
				player.queue_free()
				$ksh.pitch_scale = 0.8
				for i in range(3):
					$ksh.play()
					yield($ksh, "finished")
					$ksh.pitch_scale -= 0.2
#				$victory.play()
#				yield($victory, "finished")
#				get_tree().call_group("xxi", "load_next_level")
				get_tree().call_group("xxi", "load_target_level", target_level_path)
