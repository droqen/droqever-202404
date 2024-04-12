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

func _physics_process(_delta):
	var crx : int = int(floor(player.position.x / ROOM_WIDTH))
	var cry : int = int(floor(player.position.y / ROOM_HEIGHT))
	if rx != crx or ry != cry:
		rx = crx
		ry = cry
		rtext = $world/roomlabels.get_roomlabel_for_room(rx, ry)
		rtextlen = len(rtext)
		rtextcurchar = 0
		$camera/label.text = ""
		$camera.position = Vector2(rx * ROOM_WIDTH, ry * ROOM_HEIGHT)
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
	
