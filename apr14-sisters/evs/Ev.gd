extends Node
class_name Ev
export (String, MULTILINE) var prose : String
export (String) var left_txt : String
export (String) var right_txt : String
export (NodePath) var left_node : String
export (NodePath) var right_node : String

func get_left(): return get_node(left_node)
func get_right(): return get_node(right_node)
