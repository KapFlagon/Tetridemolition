tool

extends Node2D


class_name Piece


signal colour_value_altered


##############################################
##############################################
# Variables
onready var _block_a = $BlockA
onready var _block_b = $BlockB
onready var _block_c = $BlockC
onready var _block_d = $BlockD
onready var _blocks = [_block_a, _block_b, _block_c, _block_d] setget set_blocks, get_blocks
export var _colour: Color setget set_colour, get_colour
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
		GameEnums.PIECE_ROTATION_MOVEMENT.ZERO_TO_NINETY: [ Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0,-2), Vector2(-1,-2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.NINETY_TO_ZERO: [ Vector2(0,0), Vector2(1,0), Vector2(1,-1), Vector2(0,2), Vector2(1,2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.NINETY_TO_ONEHUNDREDEIGHTY: [ Vector2(0,0), Vector2(1,0), Vector2(1,-1), Vector2(0,2), Vector2(1,2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ONEHUNDREDEIGHTY_TO_NINETY: [ Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0,-2), Vector2(-1,-2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ONEHUNDREDEIGHTY_TO_TWOHUNDREDSEVENTY: [ Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,-2), Vector2(1,-2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.TWOHUNDREDSEVENTY_TO_ONEHUNDREDEIGHTY: [ Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,2), Vector2(-1,2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.TWOHUNDREDSEVENTY_TO_ZERO: [ Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,2), Vector2(-1,2) ],
		GameEnums.PIECE_ROTATION_MOVEMENT.ZERO_TO_TWOHUNDREDSEVENTY: [ Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,-2), Vector2(1,-2) ],
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


func set_colour(new_colour): 
	_colour = new_colour
	_update_colours()

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


func build_next_rotation_preview(target_direction):
	match target_direction:
		GameEnums.ROTATION_DIRECTION.RIGHT:
			return _calculate_next_right_rotation_matrix()
		GameEnums.ROTATION_DIRECTION.LEFT:
			return _calculate_next_left_rotation_matrix()


func _calculate_next_left_rotation_matrix():
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


func _calculate_next_right_rotation_matrix():
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


func update_rotation_data(next_rotation_matrix, target_orientation, new_grid_position):
	_current_rotation_matrix = next_rotation_matrix
	_current_piece_orientation = target_orientation
	set_grid_position(new_grid_position)
	match target_orientation:
		GameEnums.PIECE_ORIENTATION.ZERO_DEGREES:
			set_rotation_degrees(0)
		GameEnums.PIECE_ORIENTATION.NINTY_DEGREES:
			set_rotation_degrees(90)
		GameEnums.PIECE_ORIENTATION.ONEHUNDREDEIGHTY_DEGREES:
			set_rotation_degrees(180)
		GameEnums.PIECE_ORIENTATION.TWOSEVENTY_DEGREES:
			set_rotation_degrees(270)


func reset_rotation_data():
	_current_rotation_matrix = _base_rotation_matrix.duplicate(true)
	_current_piece_orientation = GameEnums.PIECE_ORIENTATION.ZERO_DEGREES
	set_rotation_degrees(0)
