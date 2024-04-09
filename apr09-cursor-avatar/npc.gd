extends Area2D

export var monologue : String = "hello"
export var monologue2 : String = "world"

func _ready(): talk_off()

func talk_on(): $talk.show()
func talk_off(): $talk.hide()
