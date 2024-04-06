extends Node2D

signal done

var line_index : int = 0
var lines : Array = []

func set_print_text(text : String):
	lines = text.split("\n\n")
	line_index = 0
	$m/m/mtc.setup(lines[line_index])
	$continue_prompt.hide()

func _physics_process(_delta):
	var pc = $Pin.pc
	if pc:
		if pc.a.pressed:
			if $continue_prompt.visible:
				if line_index + 1 < len(lines):
					line_index += 1
					$m/m/mtc.setup(lines[line_index])
					$continue_prompt.hide()
				else:
					emit_signal("done")
			else:
				$m/m/mtc.set_position_end()
	if $m/m/mtc.is_done():
		$continue_prompt.show()


func _on_mtc_char_marched(c):
	$p.play()
