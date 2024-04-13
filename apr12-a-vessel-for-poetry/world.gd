extends Node2D

export (String, FILE, "*.tscn") var first_level = "res://level_meadow.tscn"

var level : GameLevel
var lost : bool = false

func load_level(level_path : String):
	lost = false
	for child in $levelContainer.get_children():
		child.hide()
		child.queue_free()
	level = load(level_path).instance()
	level.connect("win", self, "_on_level_win")
	level.connect("lose", self, "_on_level_lose")
	$levelContainer.add_child(level)
	$u.play()

func _ready():
	load_level(first_level)

func _on_level_win():
	load_level(level.next_level)

func _on_level_lose():
	if not lost:
		lost = true
		$lose.play()
		yield($lose,"finished")
		load_level(first_level)

func _physics_process(_delta):
	if lost:
		$mus.pitch_scale *= 0.99
	elif level:
		if is_instance_valid(level.player):
			match level.player.hp:
				2:
					$mus.pitch_scale = lerp($mus.pitch_scale, 1.0, 0.1)
				1:
					$mus.pitch_scale = lerp($mus.pitch_scale, 0.9, 0.08)
				_:
					$mus.pitch_scale = lerp($mus.pitch_scale, 0.5, 0.03)
		else:
#					$mus.pitch_scale = lerp($mus.pitch_scale, 0.5, 0.03)
					$mus.pitch_scale *= 0.995
#		if level.enemy_count <= 0:
#			if abs($mus.pitch_scale-0.5)>0.1 and not $d.playing:
#				$d.play()
#				yield($d,"finished")
#				AudioServer.set_bus_effect_enabled(1, 1, false)
#		else:
#			if abs($mus.pitch_scale-1.0)>0.1 and not $u.playing:
#				$u.play()
#				yield($u,"finished")
#				AudioServer.set_bus_effect_enabled(1, 1, true)
#			$mus.pitch_scale = lerp($mus.pitch_scale, 1.0, 0.1)
