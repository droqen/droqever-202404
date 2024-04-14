extends Node2D

export (NodePath) var first_ev
var ev : Ev = null

func _ready():
	goto_ev(get_node(first_ev))

func goto_ev(_ev : Ev):
	ev = _ev
	$prose/Label.text = ev.prose
	$choices/left.text = ev.left_txt
	$choices/right.text = ev.right_txt
	$choices.curst.goto(0)
	if ev.left_txt == "" and ev.right_txt == "":
		$choices.hide()

func _on_choices_choose(choicedir):
	if choicedir < 0:
		goto_ev(ev.get_left())
	else:
		goto_ev(ev.get_right())
