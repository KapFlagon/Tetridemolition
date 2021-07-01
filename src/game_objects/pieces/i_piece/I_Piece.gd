tool


extends Tetromino


class_name I_Piece


func _ready() -> void:
	_x_offset = 0
	_y_offset = 15


func print_piece_details() -> String:
	return "I_Piece"
