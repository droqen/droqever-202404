extends Node2D

onready var textbox_screen = $"../textbox"

func display_description(d : String):
	textbox_screen.set_print_text(d)
	get_parent().stagest.goto(get_parent().NAV_TEXTBOX)
