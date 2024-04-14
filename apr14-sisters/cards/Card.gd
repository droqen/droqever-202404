extends Resource
class_name Card
export (String, MULTILINE) var prose : String
export (String) var choice_left : String
export (String) var choice_right : String
export (String, FILE, "*/cards/*res") var choice_left_goto : String
export (String, FILE, "*/cards/*res") var choice_right_goto : String
