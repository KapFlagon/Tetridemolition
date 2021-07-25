tool


extends Piece


class_name L_Piece


func _ready() -> void:
	._ready()
	_offsets = Vector2(-45,-45)
	self._local_rotation_matrix_dimensions = 3
	_build_base_rotation_matrix()


func print_piece_details() -> String:
	return "L_Piece"


func _build_base_rotation_matrix():
	# [ col_01,	col_02,	col_03 ]
	#   [ ],	[ ], 	[x],
	#   [x], 	[x], 	[x],
	#   [ ].	[ ], 	[ ],
	var col_01 = [null, $BlockA, null]
	var col_02 = [null, $BlockB, null]
	var col_03 = [$BlockC, $BlockD, null]
	_base_rotation_matrix = [col_01, col_02, col_03]
	_current_rotation_matrix = _base_rotation_matrix.duplicate(true)
