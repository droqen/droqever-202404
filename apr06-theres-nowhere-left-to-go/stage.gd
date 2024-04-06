extends Node2D

const BGM_MENU = preload("res://media/menu-theme.ogg")
const BGM_OVERWORLD = preload("res://media/overworld-theme.ogg")
const SFX_START_GAME = preload("res://media/start-game.ogg")

enum { MENU, NAV, COMBAT, NAV_TEXTBOX, COMBAT_TEXTBOX, }

onready var stagest = TinyState.new( MENU, self, "_on_stagest_chg" )

func _ready():
	$menu.connect("done", self, "_on_menu_done")
	$menu.connect("request_start_game_snd", self, "_on_menu_request_start_game_snd")
	$textbox.connect("done", self, "_on_textbox_done")
	$nav.connect("request_textbox", self, "_on_nav_request_textbox")
	$nav.connect("update_unseen_thing_count", self, "_on_nav_update_unseen_thing_count")
	
func _on_menu_done():
	stagest.goto(NAV) # i could do the animation here . . .

func _on_menu_request_start_game_snd():
	$bgm.stream = SFX_START_GAME
	$bgm.volume_db = 5
	$bgm.play()

func _on_textbox_done():
	match stagest.id:
		NAV_TEXTBOX: stagest.goto(NAV)
		COMBAT_TEXTBOX: stagest.goto(COMBAT)
		_: push_error("not in a known textbox stagest: "+str(stagest.id))
	
func _on_nav_request_textbox(d):
	$textbox.set_print_text(d)
	stagest.goto(NAV_TEXTBOX)

var unseen : int = 8
var unseen_displayed_ending : bool = false
var unseen_ending_pending : int = 0

func _on_nav_update_unseen_thing_count(c):
	unseen = c

func scon(screen:Node2D):
	screen.show()
	screen.pause_mode = Node.PAUSE_MODE_PROCESS
func scoff(screen:Node2D):
	screen.hide()
	screen.pause_mode = Node.PAUSE_MODE_STOP

func _on_stagest_chg(then,now):
	if get_tree():
		get_tree().paused = true # tree is permanently paused
	for screen in get_children(): if screen is Node2D: scoff(screen)
	match now:
		MENU:
			$bgm.stream = BGM_MENU
			$bgm.play()
			scon($menu)
		COMBAT:
			scon($combat)
		NAV:
			if then == MENU:
				$fade_blackout.show()
				$fade_dither.show()
				$nav.show()
				yield(get_tree().create_timer(1.395*1.5),"timeout")
				$fade_blackout.hide()
				$bgm.stream = BGM_OVERWORLD
				$bgm.volume_db = -12
				$bgm.play()
				yield(get_tree().create_timer(1.395),"timeout")
				$fade_dither.hide()
			else:
				if $bgm.stream != BGM_OVERWORLD:
					$bgm.stream = BGM_OVERWORLD
					$bgm.play()
			match unseen:
				-1:
					$bgm.volume_db = 0
					$bgm.play()
				0: $bgm.volume_db = -16
				1: $bgm.volume_db = -14
				2: $bgm.volume_db = -12
				3: $bgm.volume_db = -9
				4: $bgm.volume_db = -8
				5: $bgm.volume_db = -4
				_: $bgm.volume_db = 0
			scon($nav)
		NAV_TEXTBOX:
			match unseen:
				0: $bgm.volume_db = -21
				1: $bgm.volume_db = -19
				2: $bgm.volume_db = -17
				3: $bgm.volume_db = -15
				4: $bgm.volume_db = -13
				5: $bgm.volume_db = -12
				_: $bgm.volume_db = -12
			scon($textbox)
			$nav.show() # visible but paused
		COMBAT_TEXTBOX:
			scon($textbox)
			$combat.show() # visible but paused

func _physics_process(_delta):
#	if Input.is_key_pressed(KEY_ESCAPE) and not $nav/mazeplayer.can_leave: # DEBUG_PURPOSES
#		$bgm.stop()
#		unseen_displayed_ending = true
#		$textbox.set_print_text("There's nothing left to see.")
#		$nav/mazeplayer.can_leave = true
#		stagest.goto(NAV_TEXTBOX)
#
	if unseen == 0 and not unseen_displayed_ending and stagest.id == NAV and not $nav/mazeplayer.bumped:
		if unseen_ending_pending < 100:
			unseen_ending_pending += 1
		else:
			$bgm.stop()
			unseen_displayed_ending = true
			$textbox.set_print_text("There's nowhere left to go.")
			$nav/mazeplayer.can_leave = true
			stagest.goto(NAV_TEXTBOX)
	else:
		unseen_ending_pending = 0
			
