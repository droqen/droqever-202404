extends Node2D

enum { MENU, NAV, COMBAT, NAV_TEXTBOX, COMBAT_TEXTBOX, }

onready var stagest = TinyState.new( MENU, self, "_on_stagest_chg" )

func scon(screen:Node2D):
	screen.show()
	screen.pause_mode = Node.PAUSE_MODE_PROCESS
func scoff(screen:Node2D):
	screen.hide()
	screen.pause_mode = Node.PAUSE_MODE_STOP

func _on_stagest_chg(then,now):
	get_tree().paused = true # tree is permanently paused
	for screen in get_children(): scoff(screen)
	match now:
		MENU:
			scon($menu)
		COMBAT:
			scon($combat)
		NAV:
			if then == MENU:
				$fade_blackout.show()
				$fade_dither.show()
				$nav.show()
				yield(get_tree().create_timer(1),"timeout")
				$fade_blackout.hide()
				yield(get_tree().create_timer(1),"timeout")
				$fade_dither.hide()
			scon($nav)
		NAV_TEXTBOX:
			scon($textbox)
			$nav.show() # visible but paused
		COMBAT_TEXTBOX:
			scon($textbox)
			$combat.show() # visible but paused
