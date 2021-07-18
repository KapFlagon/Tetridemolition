tool


extends Tetromino


class_name O_Piece


func _ready() -> void:
	._ready()
	_offsets = Vector2(-30,-30)
	self._local_rotation_matrix_dimensions = 4
	_build_base_rotation_matrix()


func print_piece_details() -> String:
	return "O_Piece"


func _build_base_rotation_matrix():
	# Maybe replace with actual blocks...
	var first_rotation_row_01 = [false, true, true, false]		# [ ], [x], [x], [ ]
	var first_rotation_row_02 = [false, true, true, false]		# [ ], [x], [x], [ ]
	var first_rotation_row_03 = [false, false, false, false]	# [ ]. [ ], [ ], [ ]
	var first_rotation_row_04 = [false, false, false, false]	# [ ]. [ ], [ ], [ ]
	var first_rotation = [first_rotation_row_01, first_rotation_row_02, first_rotation_row_03, first_rotation_row_03]
	_base_rotation_matrix = first_rotation
	_current_rotation_matrix = _base_rotation_matrix
