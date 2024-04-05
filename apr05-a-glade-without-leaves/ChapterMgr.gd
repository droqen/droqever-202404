extends Node2D

signal done_fading_in
signal done_fading_out

const CHAPTERS = [
	"res://chapter-east-wind-blows.tscn",
	"res://chapter-the-dock.tscn",
	
	"res://chapter-west-wind-blows.tscn",
	"res://chapter-without-wind.tscn",
	"res://chapter-fallen-leaves.tscn",
]

var chapter_index = 0
var chapter = null

# Called when the node enters the scene tree for the first time.
func _ready():
	chapter_index = 0
	load_chapter(CHAPTERS[0])

func load_chapter(chapter_path):
	for child in $ChapterCtr.get_children():
		child.hide()
		child.queue_free()
	if chapter_path:
		self.chapter = load(chapter_path).instance()
		self.chapter.connect("finished", self, "next_chapter")
		$ChapterCtr.add_child(chapter)
		fade_in()
	else:
		pass # do nothing. it's effectively over.

func next_chapter():
	self.chapter.disconnect("finished", self, "next_chapter")
	fade_out()
	yield(self,"done_fading_out")
	chapter_index += 1
	if chapter_index < len(CHAPTERS):
		load_chapter(CHAPTERS[chapter_index])
	else:
		load_chapter(null)

func fade_in():
	get_tree().paused = true
	var maze = chapter.get_node("maze")
	var wout = $whiteout
	wout.clear()
	for cell in maze.get_used_cells():
		wout.set_cellv(cell, 0)
	var maze_rect = maze.get_used_rect()
	for y in range(maze_rect.position.y, maze_rect.position.y + maze_rect.size.y):
		for x in range(maze_rect.position.x, maze_rect.position.x + maze_rect.size.x):
			if wout.get_cell(x, y) >= 0:
				wout.set_cell(x, y, -1)
				$paintsound.pitch_scale = rand_range(0.2,0.4)
				$paintsound.play()
			if not debug_skip():
				yield(get_tree().create_timer(0.01),"timeout")
		if not debug_skip():
			yield(get_tree().create_timer(0.15),"timeout")
	if $paintsound.playing: yield($paintsound, "finished")
	get_tree().paused = false
	yield(get_tree().create_timer(0.5),"timeout")
	chapter.get_node("intro").resume_nodelay()
	emit_signal("done_fading_in")

func fade_out():
	get_tree().paused = true
	var intro : MarchingTextContainer = chapter.get_node("intro")
	intro.pause()
	var rtl : RichTextLabel = intro.get_node("RichTextLabel")
	while rtl.visible_characters > 0:
		rtl.visible_characters -= 1
		yield(get_tree(),"idle_frame")
	var maze = chapter.get_node("maze")
	var wout = $whiteout
	var maze_rect = maze.get_used_rect()
	for y in range(maze_rect.position.y + maze_rect.size.y - 1, maze_rect.position.y - 1, -1):
		for x in range(maze_rect.position.x + maze_rect.size.x - 1, maze_rect.position.x, -1):
			if maze.get_cell(x, y) > 0:
				wout.set_cell(x, y, 0)
			yield(get_tree(),"idle_frame")
	get_tree().paused = false
	emit_signal("done_fading_out")

func debug_skip() -> bool:
	return Input.is_key_pressed(KEY_ENTER)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
