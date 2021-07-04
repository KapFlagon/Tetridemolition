extends Node2D


var _block_dimensions: Vector2
var _grid_dimensions: Vector2
var _grid_contents
var _x_limit
var _y_limit
var _active_piece setget set_active_piece
var _decent_speed: float setget set_decent_speed
var _movement_delta

var test_piece = preload("res://src/game_objects/pieces/L_piece/L_Piece.tscn")
var _block_instancing = preload("res://src/game_objects/block/Block.tscn")


func _ready():
	_block_dimensions = Vector2(30,30)
	_grid_dimensions = Vector2(10,22)
	_x_limit = _block_dimensions.x * (_grid_dimensions.x - 1)
	_y_limit = _block_dimensions.y * (_grid_dimensions.y - 1)
	_movement_delta = 0
	_grid_contents = []
	for column in range(_grid_dimensions.x - 1):
		_grid_contents.append([])
		for rows in range(_grid_dimensions.y - 1):
			_grid_contents[column].append([])
	set_active_piece(test_piece.instance())
	


func _process(delta):
	# detect if user movement input is detected 
		# detect if user movement is allowed 
			# perform movement
	# detect if user rotation input is detected
		# detect if user rotation is allowed
			# perform rotation
	# detect if gravity movement is allowed
		# move piece downward if movement allowed
	# detect if piece is resting on other pieces
		# start timer
			# lock pieces in place by moving them to the grid
	_move_piece_down(delta)
	pass


# setters and getters
func set_decent_speed(new_decent_speed: float) -> void:
	_decent_speed = new_decent_speed

func set_active_piece(new_active_piece) -> void:
	if _active_piece != null:
		remove_child(_active_piece)
	_active_piece = new_active_piece
	# Set position before adding child
	add_child(_active_piece)
	_set_spawn_position()


func _set_spawn_position():
	_active_piece.position = Vector2(0,0)
	_active_piece.set_grid_position(Vector2(3, 0))
	var pos_x = 0
	var pos_y = 0
	var updated_x_offset = _active_piece.get_offsets().x * -1
	var updated_y_offset = _active_piece.get_offsets().y * -1
	pos_x = updated_x_offset + (_block_dimensions.x * _active_piece.get_grid_position().x)
	pos_y = updated_y_offset + (_block_dimensions.y * _active_piece.get_grid_position().y)
	_active_piece.position = Vector2(pos_x,pos_y)


func _move_piece_down(delta):
	_movement_delta += delta
	# TODO need a better way to alter the speed etc. 
	if _movement_delta > 0.2 and _active_piece != null:
		# TODO need a better way to determine if a piece is touching a surface, using the rotation matrix. (Might need to rename to collision matrix).
		if _active_piece.position.y <= _y_limit - 60:
			_movement_delta = 0
			var new_grid_position = _active_piece.get_grid_position()
			new_grid_position.y = new_grid_position.y + 1
			_active_piece.set_grid_position(new_grid_position)
			_active_piece.position.y = (_active_piece.get_offsets().x * -1) + _block_dimensions.y * _active_piece.get_grid_position().y
		else: 
			_copy_active_piece_to_grid()
	pass


func _copy_active_piece_to_grid(): 
	# Copy the piece grid position, use its rotation matrix to find block positions
	# get the colour of the piece. 
	# instance new blocks and add them to the playgrid using the transforms set position, and use correct colour
	# remove the actual active piece from the playgrid. 
	var block_colour = _active_piece.get_colour()
	print(str(_active_piece.get_current_rotation_matrix()))
	print("Active piece final position: x - " + str(_active_piece.position.x) + "   y - " + str(_active_piece.position.y))
	var og_x = _active_piece.position.x - _active_piece.get_offsets().x
	var og_y = _active_piece.position.y - _active_piece.get_offsets().y
	var x_map_01 = og_x / _block_dimensions.x
	var y_map_01 = og_y / _block_dimensions.y
	print("First position: x - " + str(x_map_01) + "   y - " + str(y_map_01))
	var x_map_02 = og_x / _grid_dimensions.x
	var y_map_02 = og_y / _grid_dimensions.y
	print("Second position: x - " + str(x_map_02) + "   y - " + str(y_map_02))
	pass
