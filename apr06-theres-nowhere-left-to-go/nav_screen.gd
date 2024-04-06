extends Node2D

signal request_textbox(textbox_text)
signal update_unseen_thing_count(count)

onready var textbox_screen = $"../textbox"

var nothing_left_to_see = false

func display_description(d : String):
	emit_signal("request_textbox", d)

func _ready():
	$mazeplayer.connect("tree_exited", self, "_on_player_exited")

var unseen_thing_count : int = 8

func _physics_process(_delta):
	var unseen : int = 0
	for child in get_children():
		if child.get('unseen'): unseen += 1
	if unseen != unseen_thing_count:
		unseen_thing_count = unseen
		emit_signal("update_unseen_thing_count", unseen_thing_count)

func _on_player_exited():
	display_description("I guess I'll go somewhere I've already been.")
	emit_signal("update_unseen_thing_count", -1)