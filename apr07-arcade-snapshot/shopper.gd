extends NavdiMazeNobody

signal moved
signal targeted_item(item)
signal finished_move_queue
signal request_buy_item(item)
signal trying_to_leave

var queuedmoves : Array = []
var moveprogress : int = 0
var target_item : MarketItem

func _ready():
	var m = $"../maze"
	setup(m, m.world_to_map(position))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if target_item and not is_instance_valid(target_item): untarget()
	
	var pc = $Pin.pc
	var a = PinButton.new()
	if pc:
		a = pc.a
		var was_no_queued = len(queuedmoves) == 0
		if pc.stick.left.pressed: queuedmoves.append(Vector2.LEFT)
		if pc.stick.up.pressed: queuedmoves.append(Vector2.UP)
		if pc.stick.right.pressed: queuedmoves.append(Vector2.RIGHT)
		if pc.stick.down.pressed: queuedmoves.append(Vector2.DOWN)
		if was_no_queued and len(queuedmoves) and target_item: untarget()
	if queuedmoves:
		if len(queuedmoves) == 1:
			moveprogress += 1
		else:
			moveprogress += 4
		if moveprogress < 7:
			if queuedmoves[0].x > 0: $SheetSprite.setup([32])
			if queuedmoves[0].y > 0: $SheetSprite.setup([41])
			if queuedmoves[0].x < 0: $SheetSprite.setup([30])
			if queuedmoves[0].y < 0: $SheetSprite.setup([21])
			var new_target_item = get_item_in_dir(queuedmoves[0])
			if target_item != new_target_item:
				target_item = new_target_item
				emit_signal("targeted_item", target_item)
		else:
			$SheetSprite.setup([31])
			if try_move(queuedmoves[0]):
				emit_signal("moved")
			moveprogress = 0
			queuedmoves.pop_front()
			if len(queuedmoves) == 0:
				emit_signal("finished_move_queue")
	elif a.pressed and target_item:
		emit_signal("request_buy_item", target_item)
	position += vector_to_center()

func untarget():
	if target_item:
		target_item = null
		emit_signal("targeted_item", null)

func is_move_legal(from, to) -> bool:
	if from == Vector2(9,9) and to == Vector2(9,10):
		emit_signal("trying_to_leave")
		return false
	
	if maze.get_cellvalue_flag(maze.get_cellv(to))==1: return false # solid
	
	var bodies_there = maze.get_bodies(to)
	if bodies_there: return false # object in the way
	
	# else . . .
	return true

func get_item_in_dir(dir) -> MarketItem:
	var bodies_there = maze.get_bodies(_cell + dir)
	for body in bodies_there:
		if body.get('IS_MARKET_ITEM'):
			return body
	return null
