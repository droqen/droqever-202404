extends NavdiMovingGuy

signal found_npc(npc_says)
signal lost_npc

var target_npc_says : String

var phase : int = 0

func _physics_process(_delta):
	var pc = $Pin.pc
	if pc:
		velocity = pc.stick.get_dpad_smoothed_vector().limit_length(1.0)
		process_slidey_move()
	var found_existing_target : bool = false
	var new_target = null
	for body in $npc_det.get_overlapping_bodies():
		if body and body.get_npc_says(phase) == target_npc_says:
			found_existing_target = true
		elif body:
			new_target = body
	
	if target_npc_says and found_existing_target:
		pass # keep
	elif new_target:
		target_npc_says = new_target.get_npc_says(phase)
		emit_signal("found_npc", target_npc_says)
	elif target_npc_says:
		target_npc_says = ""
		emit_signal("lost_npc")
