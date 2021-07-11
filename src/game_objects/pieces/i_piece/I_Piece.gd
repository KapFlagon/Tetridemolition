tool


extends Tetromino


class_name I_Piece


func _ready() -> void:
	_offsets = Vector2(-60,-30)
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
