tool

extends Node2D


class_name Tetromino


signal colour_value_altered


##############################################
##############################################
# Variables
onready var _block_a = $BlockA
onready var _block_b = $BlockB
onready var _block_c = $BlockC
onready var _block_d = $BlockD
onready var _blocks = [_block_a, _block_b, _block_c, _block_d] setget set_blocks, get_blocks
export var _colour: Color setget, get_colour
var _grid_position: Vector2 setget set_grid_position, get_grid_position
var _moving: bool setget set_moving, is_moving
var _moving_speed: float setget set_moving_speed, get_moving_speed
var _offsets: Vector2 setget , get_offsets
var _local_rotation_matrix_dimensions: int setget , get_local_rotation_matrix_dimensions
var _base_rotation_matrix 
var _current_rotation_matrix setget , get_current_rotation_matrix
var _current_piece_orientation: int setget , get_current_piece_orientation
var _rotation_checks_dictionary = {} setget , get_rotation_checks_dictionary


##############################################
##############################################

func _ready() -> void:
	_update_colours()
	_current_piece_orientation = GameEnums.PIECE_ORIENTATION.ZERO_DEGREES
	_rotation_checks_dictionary = {
		GameEnums.PIECE_ROTATION_MOVEMENT.ZERO_TO_NINETY: [ [0,0], [-1,0], [-1,1], [0,-2], [-1,-2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.NINETY_TO_ZERO: [ [0,0], [1,0], [1,-1], [0,2], [1,2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.NINETY_TO_ONEHUNDREDEIGHTY: [ [0,0], [1,0], [1,-1], [0,2], [1,2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ONEHUNDREDEIGHTY_TO_NINETY: [ [0,0], [-1,0], [-1,1], [0,-2], [-1,-2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ONEHUNDREDEIGHTY_TO_TWOHUNDREDSEVENTY: [ [0,0], [1,0], [1,1], [0,-2], [1,-2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.TWOHUNDREDSEVENTY_TO_ONEHUNDREDEIGHTY: [ [0,0], [-1,0], [-1,-1], [0,2], [-1,2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.TWOHUNDREDSEVENTY_TO_ZERO: [ [0,0], [-1,0], [-1,-1], [0,2], [-1,2] ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ZERO_TO_TWOHUNDREDSEVENTY: [ [0,0], [1,0], [1,1], [0,-2], [1,-2] ],
	}

func _init() -> void:
	pass


func _process(_delta) -> void:
	if Engine.editor_hint:
		_update_colours()
	if not Engine.editor_hint:
		pass
	pass


##############################################
##############################################
# Setters and Getters
func set_grid_position(new_grid_position):
	_grid_position = new_grid_position
	position.x = (_offsets.x * -1) + (get_block_dimensions().x * new_grid_position.x)
	position.y = (_offsets.y * -1) + (get_block_dimensions().y * new_grid_position.y)

func get_grid_position():
	return _grid_position


func set_blocks(blocks) -> void:
	_blocks = blocks
	
func get_blocks():
	return _blocks


func get_block_dimensions():
	return $BlockA.get_block_dimensions()


func get_colour():
	return _colour


func set_moving(new_moving: bool) -> void:
	_moving = new_moving

func is_moving() -> bool:
	return _moving


func set_moving_speed(new_moving_speed: float) -> void:
	_moving_speed = new_moving_speed
	
func get_moving_speed() -> float:
	return _moving_speed


func get_offsets() -> Vector2:
	return _offsets


func get_local_rotation_matrix_dimensions():
	return _local_rotation_matrix_dimensions


func get_current_rotation_matrix():
	return _current_rotation_matrix


func get_current_piece_orientation():
	return _current_piece_orientation


func get_rotation_checks_dictionary():
	return _rotation_checks_dictionary


##############################################
##############################################
# Additional functions: private
func _update_colours() -> void:
	#for block_element in _blocks:
	#	block_element.set_block_colour(_colour)
	if (_colour != $BlockA.get_block_colour()):
		$BlockA.set_block_colour(_colour)
		$BlockB.set_block_colour(_colour)
		$BlockC.set_block_colour(_colour)
		$BlockD.set_block_colour(_colour)


func print_piece_details() -> String:
	return "Tetromino parent piece"


func _build_base_rotation_matrix():
	print_rotation_matrix(_base_rotation_matrix)


func _build_next_rotation(target_direction):
	match target_direction:
		GameEnums.ROTATION_DIRECTION.RIGHT:
			return _calculate_next_right_rotation_matrix()
		GameEnums.ROTATION_DIRECTION.LEFT:
			return _calculate_next_left_rotation_matrix()


func _calculate_next_right_rotation_matrix():
	var existing_matrix = _current_rotation_matrix.duplicate(true)
	var new_matrix = _current_rotation_matrix.duplicate(true)
	var x1 = _current_rotation_matrix.size() -1
	var y1 = 0
	var x2 = 0 
	var y2 = 0
	while x1 >= 0:
		while y1 < _current_rotation_matrix.size():
			new_matrix[x2][y2] = existing_matrix[x1][y1]
			y1 += 1
			x2 += 1
		x2 = 0
		y1 = 0
		x1 -= 1
		y2 += 1
	return new_matrix


func _calculate_next_left_rotation_matrix():
	var existing_matrix = _current_rotation_matrix.duplicate(true)
	var new_matrix = _current_rotation_matrix.duplicate(true)
	var x1 = 0
	var y1 = _current_rotation_matrix.size() -1
	var x2 = 0 
	var y2 = 0
	while x1 < _current_rotation_matrix.size():
		while y1 >= 0:
			new_matrix[x2][y2] = existing_matrix[x1][y1]
			y1 -= 1
			x2 += 1
		x2 = 0
		y1 = _current_rotation_matrix.size() -1
		x1 += 1
		y2 += 1
	return new_matrix


##############################################
##############################################
# Additional Functions : public
func print_rotation_matrix(rotation_matrix):
	for row in rotation_matrix:
		var row_output = ""
		for col in row:
			var col_output = ""
			if col == true:
				col_output = "[x]"
			else:
				col_output = "[ ]"
			row_output = row_output + col_output
		print(row_output)


func _process_wall_kicks(_original_orientation, _target_orientation, _grid_local_matrix):
	pass


func rotate_piece_right(_grid_local_matrix):
	# TODO May need to examine the parameters passed to this further. 
	pass


func rotate_piece_left(_grid_local_matrix):
	pass


func get_lowest_collision_row() -> int:
	# FIXME: This may not be the best way, is it doesn't work for assymetrical pieces like the Z and S
	var lowest_matrix_collision_row = _current_rotation_matrix.size()
	var row_iterator = _current_rotation_matrix.size() - 1
	var limit = _current_rotation_matrix.size()
	while row_iterator >= 0:
		var col_iterator = 0
		while col_iterator < limit:
			if _current_rotation_matrix[row_iterator][col_iterator] is Block:
				lowest_matrix_collision_row = row_iterator
				col_iterator = _current_rotation_matrix.size()
				row_iterator = 0
			col_iterator += 1
		row_iterator -= 1
	return lowest_matrix_collision_row


func get_first_collision_column() -> int:
	var first_matrix_collision_column = 0
	var column_iterator = 0
	while column_iterator < _current_rotation_matrix.size(): 
		var row_iterator = 0
		while row_iterator < _current_rotation_matrix.size():
			if _current_rotation_matrix[row_iterator][column_iterator] is Block:
				first_matrix_collision_column = column_iterator
				column_iterator = _current_rotation_matrix.size()
				row_iterator = _current_rotation_matrix.size()
			row_iterator += 1
		column_iterator += 1
	return first_matrix_collision_column


func get_last_collision_column() -> int:
	var last_matrix_collision_column = _current_rotation_matrix.size()
	var column_iterator = _current_rotation_matrix.size() - 1
	while column_iterator >= 0:
		var row_iterator = 0
		while row_iterator < _current_rotation_matrix.size():
			if _current_rotation_matrix[row_iterator][column_iterator] is Block:
				last_matrix_collision_column = column_iterator
				column_iterator = 0
				row_iterator = _current_rotation_matrix.size()
			row_iterator += 1
		column_iterator -= 1
	return last_matrix_collision_column
