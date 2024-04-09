extends StaticBody2D

export (String,MULTILINE)var npc_says : String = "hello world"
export (String,MULTILINE)var npc_says_dark : String = "wow, whoa"
export (String,MULTILINE)var npc_says_after : String = ""

export var phase_leaves : int = 10

func get_npc_says(phase : int) -> String:
	if phase < 5: return npc_says
	elif phase == 5: return npc_says_dark
	elif phase < phase_leaves: return npc_says_after
	else: return ""
