extends Node2D

signal request_add_item_to_inventory(item)
signal left_market()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$shopper.connect("moved", self, "_on_shopper_moved")
	$shopper.connect("finished_move_queue", self, "_on_shopper_stopped")
	$shopper.connect("targeted_item", self, "_on_shopper_looked")
	$shopper.connect("request_buy_item", self, "_on_shopper_wanna_buy")
	$shopper.connect("trying_to_leave", self, "_on_shopper_wanna_leave")
	update_clock()
	update_cents(true)

var cents : int = 9025
var subsecond : int = randi() % 59
var second : int = 40 + randi() % 8
var minute : int = 39
var hour : int = 6
var closed : bool = false

func _physics_process(_delta):
	subsecond += 1
	if subsecond >= 60:
		second += 1
		subsecond = 50
		if second >= 60:
			minute += 1
			second = 0
			if minute >= 60:
				hour += 1
				minute = 0
			update_clock()
	
	if wanna_leave and $shopper/Pin.pc and $shopper/Pin.pc.a.pressed:
		emit_signal("left_market")

func update_clock():
	$time_label.text = ""
	yield(get_tree().create_timer(0.5),"timeout")
	$time_label.text = "%d:%02d" % [hour, minute]
	if hour == 7 and minute == 0:
		closed = true
		$desc_label.text = "The market is closed."
func update_cents(silent : bool = false, sike : bool = false):
	if not silent: $snd_bought.play()
	$money_label.text = ""
	yield(get_tree().create_timer(0.17),"timeout")
	$money_label.text = "You have $%d,%02d" % [floor(cents/100), cents%100]

func _on_shopper_moved():
	if $shopper.target_item:
		$desc_label.text = "" if not closed else "The market is closed."
	elif wanna_leave and $shopper._cell.y < 8:
		$desc_label.text = "Oh, you wanna stay!"
		wanna_leave = false
func _on_shopper_stopped():
	var item = $shopper.target_item
	if item:
		$desc_label.text = "You are looking at %s. %s" % [item.itemname,
			[item.itemsmell, item.itemlook, item.itemgreen][randi()%3]]
		if closed:
			$desc_label.text += "\n\nBut you can't buy it. The market is closed."
		else:
			var cost = $shopper.target_item.cents
			$desc_label.text += "\n\nPress BUTTON to buy it ($%d,%02d)" % [floor(cost/100), cost%100]
func _on_shopper_looked(item):
	if item:
		pass
	else:
		$desc_label.text = ""
func _on_shopper_wanna_buy(item):
	if closed:
		$desc_label.text = "You can't buy it. The market is closed."
		return
	if item.cents <= cents:
		cents -= item.cents
		item.queue_free()
		$shopper.untarget()
		update_cents()
		$desc_label.text = "You bought %s!" % item.itemname
		emit_signal("request_add_item_to_inventory", item)
	else:
		$shopper.untarget()
		$desc_label.text = "You can't afford that."
		$snd_no.play()
var wanna_leave : bool = false
func _on_shopper_wanna_leave():
	$desc_label.text = "Ready to go?\n\nPress BUTTON to leave"
	wanna_leave = true
