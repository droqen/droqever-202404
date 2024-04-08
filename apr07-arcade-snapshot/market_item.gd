extends NavdiMazeNobody
class_name MarketItem
export var itemname : String = "a ternary of steep-grade luckies"
export var itemsmell : String = "They smell sweet and fresh."
export var itemlook : String = "They look healthy."
export var itemgreen : String = "They are a sickeningly verdant green."
export var cents : int = 100

const IS_MARKET_ITEM = true

func _ready():
	var m = $"../maze"
	setup(m, m.world_to_map(position))
