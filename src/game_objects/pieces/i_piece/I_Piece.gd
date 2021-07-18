tool


extends Tetromino


class_name I_Piece


func _ready() -> void:
	._ready()
	_offsets = Vector2(-60,-30)
	self._local_rotation_matrix_dimensions = 4
	_build_base_rotation_matrix()
	_rotation_checks_dictionary = {
		GameEnums.PIECE_ROTATION_MOVEMENT.ZERO_TO_NINETY: [ [0,0], [-2,0], [1,0], [-2,-1], [1,2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.NINETY_TO_ZERO: [ [0,0], [2,0], [-1,0], [2,1], [-1,-2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.NINETY_TO_ONEHUNDREDEIGHTY: [ [0,0], [-1,0], [2,0], [-1,2], [2,-1] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ONEHUNDREDEIGHTY_TO_NINETY: [ [0,0], [1,0], [-2,0], [1,-2], [-2,1] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ONEHUNDREDEIGHTY_TO_TWOHUNDREDSEVENTY: [ [0,0], [2,0], [-1,0], [2,1], [-1,-2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.TWOHUNDREDSEVENTY_TO_ONEHUNDREDEIGHTY: [ [0,0], [-2,0], [1,0], [-2,-1], [1,2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.TWOHUNDREDSEVENTY_TO_ZERO: [ [0,0], [1,0], [-2,0], [1,-2], [-2,1] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ZERO_TO_TWOHUNDREDSEVENTY: [ [0,0], [-1,0], [2,0], [-1,2], [2,-1] ],
	}


func print_piece_details() -> String:
	return "I_Piece"


func _build_base_rotation_matrix():
	# Maybe replace with actual blocks...
	var first_rotation_row_01 = [false, false, false, false]	# [ ], [ ], [ ], [ ]
	var first_rotation_row_02 = [true, true, true, true]		# [x], [x], [x], [x]
	var first_rotation_row_03 = [false, false, false, false]	# [ ]. [ ], [ ], [ ]
	var first_rotation_row_04 = [false, false, false, false]	# [ ]. [ ], [ ], [ ]
	var first_rotation = [first_rotation_row_01, first_rotation_row_02, first_rotation_row_03, first_rotation_row_03]
	_base_rotation_matrix = first_rotation
	_current_rotation_matrix = _base_rotation_matrix
