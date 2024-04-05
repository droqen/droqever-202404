extends Label

onready var moth = $"../moonmoth"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if moth.damage > 0:
		show()
		if moth.damage == 1:
			text = "you were hit\nonce"
		else:
			text = "you were hit\n"+str(moth.damage)+" times"
	else:
		hide()
