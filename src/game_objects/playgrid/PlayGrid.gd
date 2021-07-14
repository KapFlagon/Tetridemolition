extends Node2D


var _block_dimensions: Vector2
var _grid_dimensions: Vector2
var _grid_contents
var _x_limit
var _y_limit
var _active_piece: Tetromino setget set_active_piece
var _decent_speed: float setget set_decent_speed
var _movement_delta

var test_piece = preload("res://src/game_objects/pieces/L_piece/L_Piece.tscn")
var _block_instancing = preload("res://src/game_objects/block/Block.tscn")


##############################################
##############################################
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
			_grid_contents[column].append(false)
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


##############################################
##############################################
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
	_active_piece.set_grid_position(Vector2(3, 0))


func _move_piece_down(delta):
	_movement_delta += delta
	# TODO need a better way to alter the speed etc. 
	if _movement_delta > 0.5 and _active_piece != null:
		# TODO need a better way to determine if a piece is touching a surface, using the rotation matrix. (Might need to rename to collision matrix).
		_movement_delta = 0
		var piece_grid_chunk_depth = _active_piece.get_local_rotation_matrix_dimensions() + _active_piece.get_grid_position().y 
		if piece_grid_chunk_depth < _grid_dimensions.y - 1:
			# iterate through the piece current rotation matrix, and compare with the same cells in next row down. 
			_will_downward_piece_collide_with_grid_contents()
			# HACK For now this just moves things downward in a dumb way, no detection yet. 
			var old_position_vector = _active_piece.get_grid_position()
			var new_position_vector = Vector2(old_position_vector.x, old_position_vector.y + 1)
			_active_piece.set_grid_position(new_position_vector)
			# TODO start the timer for allowing a piece to slide/rotate before becoming fully fixed
			# If the next line has a block or wall in the way, it can't go any further. 
			pass
		else: 
			if _active_piece != null:
				# FIXME this is just a dummy line for now, replace later with _copy_active_piece_to_grid()
				print("done")
				_active_piece.queue_free()
			pass
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


func _get_local_grid_matrix_for_active_piece():
	# TODO Need to expand the local matrix so that it also accounts for the rotation system. 
	# Need to pad this matrix by 2 in ALL directions, so a 4x4 piece matrix will return an 8x8 local matrix to be used in rotation system.
	# TODO need to also account for walls, so if a wall is detected, it and everything past that will be "false" in the matrix.
	var size_increase = _active_piece.get_local_rotation_matrix_dimensions() - 1
	var start_position_in_grid = _active_piece.get_grid_position()
	var local_grid_matrix = []
	for row_iterator in range(size_increase):
		for column_iterator in range(size_increase):
			local_grid_matrix[row_iterator][column_iterator] = _grid_contents[_active_piece.get_grid_position().x + row_iterator][_active_piece.get_grid_position().y + column_iterator]
	return local_grid_matrix


func _will_downward_piece_collide_with_grid_contents() -> bool:
	var piece_pos = _active_piece.get_grid_position()
	var piece_rotation_collision_matrix = _active_piece.get_current_rotation_matrix()
	
	
	var iterator = _active_piece.get_local_rotation_matrix_dimensions() - 1
	while iterator >= 0:
		var inner_iterator = 0
		while inner_iterator < piece_rotation_collision_matrix.size():
			if piece_rotation_collision_matrix[iterator][inner_iterator] == true:
				var value = _grid_contents[piece_pos.y + inner_iterator][piece_pos.x + iterator]  # FIXME pick up from here. 
				if value == true:
					if piece_pos.y +_active_piece.get_local_rotation_matrix_dimensions() > _y_limit:
						print("collision detected at bottom")
			inner_iterator += 1
		iterator -= 1
	return false
