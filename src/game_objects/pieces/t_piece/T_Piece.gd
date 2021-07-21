tool


extends Tetromino


class_name T_Piece


func _ready() -> void:
	._ready()
	_offsets = Vector2(-45,-45)
	self._local_rotation_matrix_dimensions = 3
	_build_base_rotation_matrix()


func print_piece_details() -> String:
	return "T_Piece"


func _build_base_rotation_matrix():
	# Maybe replace with actual blocks...
	var row_01 = [null, $BlockA, null]				# [ ], [x], [ ]
	var row_02 = [$BlockB, $BlockC, $BlockD]		# [x], [x], [x]
	var row_03 = [null, null, null]					# [ ]. [ ], [ ]
	_base_rotation_matrix = [row_01, row_02, row_03]
	_current_rotation_matrix = _base_rotation_matrix.duplicate(true)
