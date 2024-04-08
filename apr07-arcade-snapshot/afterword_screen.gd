extends Node2D

var bought_lines : Array
var blindex : int = 0
var pending : int = 60

func setup(bl):
	self.bought_lines = bl
	
func _physics_process(_delta):
	if pending == 99:
		pass
	elif pending > 0:
		pending -= 1
	elif blindex < len(bought_lines):
		$Label.text += bought_lines[blindex]
		blindex += 1
		pending = 60
	elif blindex == 0:
		$Label.text += "... Nothing at all. You walked out of there as you came in, wearing your sockless leather dress shoes, and went back to work."
		$Label.text += "\n\n THE END"
		pending = 99
	else:
		$Label.text += "THE END"
		pending = 99
