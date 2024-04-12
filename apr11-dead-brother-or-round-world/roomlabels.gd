extends Node2D

const ROOM_WIDTH : int = 220
const ROOM_HEIGHT : int = 150

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
func get_roomlabel_for_room(rx:int,ry:int):
	for _label in get_children():
		var label : Label = _label
		var label_pos = label.rect_position + label.rect_size * 0.5
		var label_rx : int = int(floor(label_pos.x / ROOM_WIDTH))
		var label_ry : int = int(floor(label_pos.y / ROOM_HEIGHT))
		if label_rx == rx and label_ry == ry:
			return label.text
	match ry:
		2: return "XXI. the world"
		3: return "could not be expressed in"
		4: return "anything less than itself"
		5,6: return "forever,"
		7: return "forever."
		_: return ""
	return "(none @\n"+str(rx)+", "+str(ry)+")"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
