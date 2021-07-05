tool


extends Tetromino


class_name L_Piece


func _ready() -> void:
	_offsets = Vector2(-45,-45)
	self._local_rotation_matrix_dimensions = 3
	_build_base_rotation_matrix()
	rotate_piece_right()
	


func print_piece_details() -> String:
	return "L_Piece"


func _build_base_rotation_matrix():
	
	# Maybe replace with actual blocks...
	var first_rotation_row_01 = [false, false, true]	# [ ], [ ], [x]
	var first_rotation_row_02 = [true, true, true]		# [x], [x], [x]
	var first_rotation_row_03 = [false, false, false]	# [ ]. [ ], [ ]
	var first_rotation = [first_rotation_row_01, first_rotation_row_02, first_rotation_row_03]
	
	#var second_rotation_row_01 = [false, true, false]	# [ ], [x], [ ]
	#var second_rotation_row_02 = [false, true, false]	# [ ], [x], [ ]
	#var second_rotation_row_03 = [false, true, true]	# [ ]. [x], [x]
	#var second_rotation = [second_rotation_row_01, second_rotation_row_02, second_rotation_row_03]
	
	#var third_rotation_row_01 = [false, false, false]	# [ ], [ ], [ ]
	#var third_rotation_row_02 = [true, true, true]		# [x], [x], [x]
	#var third_rotation_row_03 = [true, false, false]	# [x]. [ ], [ ]
	#var third_rotation = [third_rotation_row_01, third_rotation_row_02, third_rotation_row_03]
	
	#var fourth_rotation_row_01 = [true, true, false]	# [x], [x], [ ]
	#var fourth_rotation_row_02 = [false, true, false]	# [ ], [x], [ ]
	#var fourth_rotation_row_03 = [false, true, false]	# [ ]. [x], [ ]
	#var fourth_rotation = [fourth_rotation_row_01, fourth_rotation_row_02, fourth_rotation_row_03]
	
	#var rotations = [ first_rotation, second_rotation, third_rotation, fourth_rotation ]
	#set_base_rotation_matrix(rotations)
	
	set_base_rotation_matrix(first_rotation)
	_current_rotation_matrix = get_base_rotation_matrix()
	._build_base_rotation_matrix()
