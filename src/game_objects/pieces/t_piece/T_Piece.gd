tool


extends Tetromino


class_name T_Piece


func _ready() -> void:
	_x_offset = 15
	_y_offset = 0


func print_piece_details() -> String:
	return "T_Piece"
