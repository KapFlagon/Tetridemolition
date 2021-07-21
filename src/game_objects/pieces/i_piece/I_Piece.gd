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
	var row_01 = [null, null, null, null]					# [ ], [ ], [ ], [ ]
	var row_02 = [$BlockA, $BlockB, $BlockC, $BlockD]		# [x], [x], [x], [x]
	var row_03 = [null, null, null, null]					# [ ]. [ ], [ ], [ ]
	var row_04 = [null, null, null, null]					# [ ]. [ ], [ ], [ ]
	_base_rotation_matrix = [row_01, row_02, row_03, row_04]
	_current_rotation_matrix = _base_rotation_matrix.duplicate(true)


func set_grid_position(new_grid_position):
	_grid_position = new_grid_position
	position.x = (_offsets.x * -1) + (get_block_dimensions().x * new_grid_position.x)
	position.y = (_offsets.y * -1) + (get_block_dimensions().y * new_grid_position.y) + get_block_dimensions().y
