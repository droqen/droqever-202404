extends NavdiMovingGuy

signal exited_stage_right

export var lowest_ypos : int = 95
export var going_left : bool = false

onready var maze = $"../maze"

enum { NONE=24, DRYGRASS, SNOWHILL, LEAVES, }

onready var terrainst = TinyState.new(NONE,self,"_on_terrainst_chg")

func _on_terrainst_chg(_then,now):
	call_deferred('set_collision_mask_bit', 0, now == DRYGRASS)

var last_cell : Vector2
var stick : Vector2

func _physics_process(_delta):
	var cell : Vector2 = maze.world_to_map(position)
	if cell != last_cell:
		match maze.get_cellv(last_cell):
			13:
				maze.set_cellv(last_cell, 12)
		last_cell = cell
		match maze.get_cellv(cell):
			12, 13:
				maze.set_cellv(cell, 13)
				terrainst.goto(DRYGRASS)
			14:
				terrainst.goto(SNOWHILL)
			11:
				maze.set_cellv(cell, 11, not maze.is_cell_x_flipped(cell.x, cell.y))
			_:
				terrainst.goto(NONE)
	
	stick = Vector2.ZERO
	if pin.pc:
		stick = pin.pc.stick.get_dpad_smoothed_vector()
	if going_left:
		if (180-position.x) < 4: stick.x = -1
	else:
		if position.x < 4: stick.x = 1
	
	if stick.x != 0: spr.flip_h = stick.x < 0
	
	var spd : float = 0.3 if terrainst.id == DRYGRASS else 0.6
	if terrainst.id == SNOWHILL: velocity *= 0.8
	velocity += (stick * spd - velocity).limit_length(0.1)
	if position.y-3 < 5 and velocity.y < 0: velocity.y = 0
	if position.y-3 > lowest_ypos and velocity.y > 0: velocity.y = 0
	if going_left:
		if (180-position.x) < 5 and velocity.x > 0: velocity.x = 0
		if (180-position.x) >= 183:
			velocity.x = -1 # forced left
			hide()
			emit_signal("exited_stage_right") # misnomer. but whatever.
	else:
		if position.x < 5 and velocity.x < 0: velocity.x = 0
		if position.x >= 183:
			velocity.x = 1 # forced right
			hide()
			emit_signal("exited_stage_right")
	
	if stick or velocity:
		spr.setup([2,1],10)
	else:
		spr.setup([1,1,2],30)
	
	process_slidey_move()

	# avoid diagonal crossings
	var cell_center = maze.map_to_center(cell)
	var to_cell_center = cell_center - position
	if abs(to_cell_center.x) > 4 and abs(to_cell_center.y) > 4:
		if abs(velocity.x) > abs(velocity.y):
			position.y += sign(to_cell_center.y)
		else:
			position.x += sign(to_cell_center.x)
