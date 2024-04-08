extends Node2D

enum {
	IN_CITY, IN_MARKET, AFTERWORD,
}

onready var stagest = TinyState.new(IN_MARKET, self, "_on_stagest_chg")
func _ready():
	$market.connect("request_add_item_to_inventory", self, "_add_mitem")
	$market.connect("left_market", self, "_on_left_market")
	get_tree().paused = true
func _on_stagest_chg(_then,now):
	for child in get_children():
		if child is Node2D:
			child.hide()
			child.pause_mode = Node.PAUSE_MODE_STOP
		match now:
			IN_CITY: activate_nodes([$city])
			IN_MARKET: activate_nodes([$market])
			AFTERWORD:
				$afterword.setup(bought_lines)
				activate_nodes([$afterword])
			
func activate_nodes(nodes : Array):
	for node in nodes:
		node.show()
		node.pause_mode = Node.PAUSE_MODE_PROCESS

var bought_lines = []

func _add_mitem(mitem : MarketItem):
	bought_lines.append("- %s. %s\n\n" % [mitem.itemname, 
		[mitem.itemsmell, mitem.itemlook, mitem.itemgreen][randi()%3]
	])

func _on_left_market():
	stagest.goto(AFTERWORD)
