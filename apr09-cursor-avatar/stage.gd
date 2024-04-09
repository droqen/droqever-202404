extends Node2D

var m1 : String = ""
var m2 : String = ""
var pulsar : int = 0
var mindex : int = 0

func _on_snail_npc_changed(npc):
	if npc and npc.name == "bottom":
		m1 = "promises"
		m2 = "promises"
		$camera/textbox/Label.text = "promises"
		$world/snail.queue_free()
		return
	if npc:
		m1 = npc.monologue
		m2 = npc.monologue2
	else:
		m1 = ""
		m2 = ""
	pulsar = 30
	mindex = 0
	$camera/textbox/Label.text = "#>"

func _physics_process(_delta):
	if m1 == m2 and m1 != "":
		return # dont 
	pulsar += 1
	if pulsar >= 120:
		mindex = (mindex+1)%2
		pulsar = 0
	if pulsar < 10:
		$camera/textbox/Label.text = ""
	else:
		$camera/textbox/Label.text = m1 if mindex==0 else m2
