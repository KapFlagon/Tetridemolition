tool


extends Tetromino


class_name L_Piece


func _ready() -> void:
	_offsets = Vector2(-45,-45)
	self._local_rotation_matrix_dimensions = 3
	_build_base_rotation_matrix()


func print_piece_details() -> String:
	return "L_Piece"


func _build_base_rotation_matrix():
	# Maybe replace with actual blocks...
	var first_rotation_row_01 = [false, false, true]	# [ ], [ ], [x]
	var first_rotation_row_02 = [true, true, true]		# [x], [x], [x]
	var first_rotation_row_03 = [false, false, false]	# [ ]. [ ], [ ]
	var first_rotation = [first_rotation_row_01, first_rotation_row_02, first_rotation_row_03]
	_base_rotation_matrix = first_rotation
