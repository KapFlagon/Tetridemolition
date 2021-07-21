tool


extends Tetromino


class_name O_Piece


func _ready() -> void:
	._ready()
	_offsets = Vector2(-30,-30)
	self._local_rotation_matrix_dimensions = 3
	_build_base_rotation_matrix()


func print_piece_details() -> String:
	return "O_Piece"


func _build_base_rotation_matrix():
	# Maybe replace with actual blocks...
	var row_01 = [$BlockA, $BlockB]		# [x], [x]
	var row_02 = [$BlockC, $BlockD]		# [x], [x]
	_base_rotation_matrix = [row_01, row_02]
	_current_rotation_matrix = _base_rotation_matrix.duplicate(true)


func _calculate_next_right_rotation_matrix():
	# Override to actually prevent piece rotation
	pass


func _calculate_next_left_rotation_matrix():
	# Override to actually prevent piece rotation
	pass
