extends Node2D


class_name Tetromino


# Variables
export var _colour: Color
var _blocks setget set_blocks, get_blocks
var _moving: bool setget set_moving, is_moving
var _moving_speed: float setget set_moving_speed, get_moving_speed


func _ready() -> void:
	pass


func _process(delta) -> void:
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
	_blocks = [$BlockA, $BlockB, $BlockC, $BlockD]
	for block_element in _blocks:
		block_element.set_block_colour(_colour)
