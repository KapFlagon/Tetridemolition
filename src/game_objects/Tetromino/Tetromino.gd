tool

extends Node2D


class_name Tetromino


signal colour_value_altered


# Variables
onready var _block_a = $BlockA
onready var _block_b = $BlockB
onready var _block_c = $BlockC
onready var _block_d = $BlockD
onready var _blocks = [_block_a, _block_b, _block_c, _block_d] setget set_blocks, get_blocks
export var _colour: Color
var _moving: bool setget set_moving, is_moving
var _moving_speed: float setget set_moving_speed, get_moving_speed


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
func set_blocks(blocks) -> void:
	_blocks = blocks
func get_blocks():
	return _blocks

func set_moving(new_moving: bool) -> void:
	_moving = new_moving
func is_moving() -> bool:
	return _moving

func set_moving_speed(new_moving_speed: float) -> void:
	_moving_speed = new_moving_speed
func get_moving_speed() -> float:
	return _moving_speed


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
