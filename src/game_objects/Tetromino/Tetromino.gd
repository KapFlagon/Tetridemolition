tool

extends Node2D


class_name Tetromino


signal colour_value_altered


enum _Rotation_Direction {LEFT, RIGHT}


# Variables
var _grid_position: Vector2 setget set_grid_position, get_grid_position
onready var _block_a = $BlockA
onready var _block_b = $BlockB
onready var _block_c = $BlockC
onready var _block_d = $BlockD
onready var _blocks = [_block_a, _block_b, _block_c, _block_d] setget set_blocks, get_blocks
export var _colour: Color setget, get_colour
var _moving: bool setget set_moving, is_moving
var _moving_speed: float setget set_moving_speed, get_moving_speed
var _offsets: Vector2 setget , get_offsets
var _local_rotation_matrix_dimensions: int setget set_local_rotation_matrix_dimensions, get_local_rotation_matrix_dimensions
var _local_rotation_matrix setget set_local_rotation_matrix, get_local_rotation_matrix
var _current_rotation_matrix setget , get_current_rotation_matrix


func _ready() -> void:
	_update_colours()
	pass

func _init() -> void:
	pass


func _process(delta) -> void:
	if Engine.editor_hint:
		_update_colours()
	if not Engine.editor_hint:
		pass
	pass


# Setters and Getters
func set_grid_position(new_grid_position):
	_grid_position = new_grid_position

func get_grid_position():
	return _grid_position


func set_blocks(blocks) -> void:
	_blocks = blocks
	
func get_blocks():
	return _blocks

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


func set_local_rotation_matrix_dimensions(new_local_rotation_matrix_dimensions):
	_local_rotation_matrix_dimensions = new_local_rotation_matrix_dimensions

func get_local_rotation_matrix_dimensions():
	return _local_rotation_matrix_dimensions


func set_local_rotation_matrix(new_local_rotation_matrix):
	_local_rotation_matrix = new_local_rotation_matrix

func get_local_rotation_matrix():
	return _local_rotation_matrix


func get_current_rotation_matrix():
	return _current_rotation_matrix


# Additional functions
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


func _build_local_rotation_matrix():
	pass


func _build_next_rotation(rotation_array, target_direction):
	pass


func rotate_piece_right(grid_local_matrix):
	pass


func rotate_piece_left(grid_local_matrix):
	pass
