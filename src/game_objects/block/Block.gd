tool


extends Node2D


class_name Block


# Variables
var _grid_position: Vector2 setget set_grid_position, get_grid_position
var _block_dimensions: Vector2 setget set_block_dimensions, get_block_dimensions
var _block_colour: Color setget set_block_colour, get_block_colour
var _current_position: Vector2 setget set_current_position, get_current_position


# Called when the node enters the scene tree for the first time.
func _ready():
	_block_dimensions = Vector2(30,30)
	if _block_colour != $ColorRect.color:
			$ColorRect.color = _block_colour
	pass # Replace with function body.


func _process(_delta) -> void:
	if Engine.editor_hint:
		if _block_colour != $ColorRect.color:
			$ColorRect.color = _block_colour


# Setters and Getters
func set_grid_position(new_grid_position: Vector2) -> void:
	_grid_position = new_grid_position
	position.x = _grid_position.x * _block_dimensions.x
	position.y = _grid_position.y * _block_dimensions.y
func get_grid_position() -> Vector2:
	return _grid_position

func set_block_dimensions(new_block_dimensions: Vector2) -> void: 
	_block_dimensions = new_block_dimensions
func get_block_dimensions() -> Vector2:
	return _block_dimensions

func set_block_colour(new_colour: Color) -> void:
	_block_colour = new_colour
	$ColorRect.color = _block_colour
func get_block_colour() -> Color:
	return _block_colour

func set_current_position(new_position: Vector2) -> void:
	_current_position = new_position
func get_current_position() -> Vector2:
	return _current_position
