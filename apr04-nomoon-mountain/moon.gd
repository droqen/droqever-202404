extends KinematicBody2D

onready var bank = $"../bank"
onready var moonmoth = $"../moonmoth"

var energy : int = 99
var reload : int = 99

func _physics_process(delta):
	var to_moth = moonmoth.position - position
	var to_moth_dist = to_moth.length()
	
	if energy < 99:
		if reload >= 85:
			energy += 5
		elif reload >= 75:
			energy += 3
		elif reload >= 25:
			energy += 2
		else:
			energy += 1
	elif moonmoth.bufs.has(moonmoth.SHOOTBUF):
		energy = 45
		reload -= 5
		bank.spawn("moonshot", -1).setup(bank, position, -to_moth.normalized())
		bank.spawn("moonshot", -1).setup(bank, position, -to_moth.normalized()).setup_mini(180,180)
	elif reload < 99:
		reload += 1
	
	if to_moth_dist < 6 or moonmoth.energy < 80:
		$SheetSprite.setup([11])
		energy = 80
	elif to_moth_dist < 8 or moonmoth.energy < 99:
		$SheetSprite.setup([12])
		energy = 80
	else:
		if energy >= 90: $SheetSprite.setup([13])
		elif energy >= 82: $SheetSprite.setup([14])
		elif energy >= 74: $SheetSprite.setup([15])
		elif energy >= 66: $SheetSprite.setup([16])
		elif energy >= 58: $SheetSprite.setup([17])
		elif energy >= 50: $SheetSprite.setup([18])
		elif energy >= 40: $SheetSprite.setup([19])
	
	var hold_dist = 10
	var hold_power = 0.1
	
#	var hold_dist = 5
#	var hold_power = 0.2
#	if moonmoth.floorst.id or moonmoth.leftwallst.id != moonmoth.rightwallst.id:
#		hold_dist = 10
#		hold_power = 0.1
#		if to_moth_dist < hold_dist:
#			move_and_slide(-to_moth.normalized() * 8.0)
	
	if to_moth_dist > hold_dist + 1:
		move_and_slide(to_moth * hold_power / delta)
	if to_moth_dist > hold_dist + 2:
		move_and_slide(to_moth * hold_power / delta)
#		position += to_moth * 0.2
	if true:
#	if moonmoth.floorst.id or moonmoth.leftwallst.id != moonmoth.rightwallst.id:
		var aim_dir : Vector2 = Vector2(0, 0)
		if moonmoth.floorst.id and moonmoth.leftwallst.id != moonmoth.rightwallst.id:
			aim_dir = Vector2(-moonmoth.facest.id,-1)
			if moonmoth.stick.y > 0: aim_dir.x *= 0.01
			if moonmoth.stick.x > 0 and aim_dir.x < 0: aim_dir.y *= 0.01
			if moonmoth.stick.x < 0 and aim_dir.x > 0: aim_dir.y *= 0.01
			move_and_slide(Vector2(moonmoth.velocity.x, 0) / delta)
			move_and_slide(Vector2(0, moonmoth.velocity.y) / delta)
		elif moonmoth.floorst.id:
			aim_dir = Vector2(0,-1)
			move_and_slide(Vector2(moonmoth.velocity.x, 0) / delta)
		elif moonmoth.leftwallst.id != moonmoth.rightwallst.id:
			aim_dir = Vector2(-moonmoth.facest.id,0)
			move_and_slide(Vector2(0, moonmoth.velocity.y) / delta)
			
		else:
			aim_dir = Vector2.DOWN
			
		position = lerp(position, moonmoth.position + hold_dist * aim_dir.normalized(), 0.05)
