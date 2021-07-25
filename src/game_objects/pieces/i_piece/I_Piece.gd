tool


extends Piece


class_name I_Piece


func _ready() -> void:
	._ready()
	_offsets = Vector2(-60,-30)
	self._local_rotation_matrix_dimensions = 4
	_build_base_rotation_matrix()
	_rotation_checks_dictionary = {
		GameEnums.PIECE_ROTATION_MOVEMENT.ZERO_TO_NINETY: [ Vector2(0,0), Vector2(-2,0), Vector2(1,0), Vector2(-2,-1), Vector2(1,2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.NINETY_TO_ZERO: [ Vector2(0,0), Vector2(2,0), Vector2(-1,0), Vector2(2,1), Vector2(-1,-2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.NINETY_TO_ONEHUNDREDEIGHTY: [ Vector2(0,0), Vector2(-1,0), Vector2(2,0), Vector2(-1,2), Vector2(2,-1) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ONEHUNDREDEIGHTY_TO_NINETY: [ Vector2(0,0), Vector2(1,0), Vector2(-2,0), Vector2(1,-2), Vector2(-2,1) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ONEHUNDREDEIGHTY_TO_TWOHUNDREDSEVENTY: [ Vector2(0,0), Vector2(2,0), Vector2(-1,0), Vector2(2,1), Vector2(-1,-2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.TWOHUNDREDSEVENTY_TO_ONEHUNDREDEIGHTY: [ Vector2(0,0), Vector2(-2,0), Vector2(1,0), Vector2(-2,-1), Vector2(1,2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.TWOHUNDREDSEVENTY_TO_ZERO: [ Vector2(0,0), Vector2(1,0), Vector2(-2,0), Vector2(1,-2), Vector2(-2,1) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ZERO_TO_TWOHUNDREDSEVENTY: [ Vector2(0,0), Vector2(-1,0), Vector2(2,0), Vector2(-1,2), Vector2(2,-1) ],
	}


func print_piece_details() -> String:
	return "I_Piece"


func _build_base_rotation_matrix():
	# [ col_01,	col_02,	col_03,	col_04]
	#   [ ],	[ ], 	[ ], 	[ ]
	#   [x], 	[x], 	[x], 	[x]
	#   [ ].	[ ], 	[ ], 	[ ]
	#   [ ].	[ ], 	[ ], 	[ ]
	var col_01 = [null, $BlockA, null, null]
	var col_02 = [null, $BlockB, null, null]
	var col_03 = [null, $BlockC, null, null]
	var col_04 = [null, $BlockD, null, null]
	_base_rotation_matrix = [col_01, col_02, col_03, col_04]
	_current_rotation_matrix = _base_rotation_matrix.duplicate(true)


func set_grid_position(new_grid_position):
	_grid_position = new_grid_position
	position.x = (_offsets.x * -1) + (get_block_dimensions().x * new_grid_position.x)
	position.y = (_offsets.y * -1) + (get_block_dimensions().y * new_grid_position.y) + get_block_dimensions().y
