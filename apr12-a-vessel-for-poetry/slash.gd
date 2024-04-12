extends Area2D

var life : int = 0

enum {
	WINDUP = 13,
	HURT = 14,
	FADE_1 = 15,
	FADE_2 = 16,
}

var slashst = TinyState.new(0, self, "_on_slashst_chg", true)

func _on_slashst_chg(_then,now):
	match now:
		HURT:
			$CollisionShape2D.disabled = false
		_:
			$CollisionShape2D.disabled = true

func setup(faceleft : bool):
	position.x += -10 if faceleft else 10
	$SheetSprite.set_frame_index(00)
	life = len($SheetSprite._frames) * $SheetSprite._frame_period
	slashst.goto(WINDUP)

func _physics_process(_delta):
	slashst.goto($SheetSprite.frame)
	life -= 1
	if life <= 0: queue_free() # bye
