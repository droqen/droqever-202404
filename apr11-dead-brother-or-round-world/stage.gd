extends Node2D

const ROOM_WIDTH : int = 220
const ROOM_HEIGHT : int = 150

onready var cam = $camera
onready var player = $world/choosy
var rx : int = -1
var ry : int = -1
var rtext : String = ""
var rtextlen : int = 0
var rtextcurchar : int = 0
var rtextcurcharsub : int = 0

var forever_loop_trigger_next : float = 0.0

func loop_forever():
	if $mus.playing:
		$mus.stop()
		$musShortLoop.play()

func _physics_process(delta):
	if forever_loop_trigger_next > 0:
		if forever_loop_trigger_next < 0.01:
			if $mus.get_playback_position() < 1.00:
				$mus.stop()
				$musShortLoop.play()
				forever_loop_trigger_next = 0.0
		else:
			if $mus.get_playback_position() + delta >= forever_loop_trigger_next:
				$mus.stop()
				$musShortLoop.play()
				forever_loop_trigger_next = 0.0
	
	var crx : int = int(floor(player.position.x / ROOM_WIDTH))
	var cry : int = int(floor(player.position.y / ROOM_HEIGHT))
	if rx != crx or ry != cry:
		if crx == 4 and cry == -1:
			var looplength = $musShortLoop.stream.get_length()
			forever_loop_trigger_next = ceil($mus.get_playback_position()/looplength)*looplength
			if forever_loop_trigger_next > $mus.stream.get_length() - 1:
				forever_loop_trigger_next = 0.001
		if rx == 4 and ry == -1:
			if crx < 4:
				player.position.x += ROOM_WIDTH
			else:
				player.position.x -= ROOM_WIDTH
			rtext = $world/roomlabels.get_roomlabel_for_room(rx, ry)
			rtextlen = len(rtext)
			rtextcurchar = 0
			$camera/label.text = ""
		else:
			rx = crx
			ry = cry
			if ry <= 7:
				rtext = $world/roomlabels.get_roomlabel_for_room(rx, ry)
				rtextlen = len(rtext)
				rtextcurchar = 0
				$camera/label.text = ""
			$camera.position = Vector2(rx * ROOM_WIDTH, ry * ROOM_HEIGHT)
		if ry > 2:
			$mus.volume_db = 0 - (ry-2) * 5
	if rtextcurcharsub > 0:
		rtextcurcharsub -= 1
	else:
		rtextcurcharsub = 1
		if rtextcurchar < rtextlen:
			$camera/label.text += rtext[rtextcurchar]
			$print.play()
			match rtext[rtextcurchar]:
				',', '.', '!', '?': rtextcurcharsub = 8
		rtextcurchar += 1
		if rtextcurchar < rtextlen:
			match rtext[rtextcurchar]:
				'\n': rtextcurcharsub = 30
	
