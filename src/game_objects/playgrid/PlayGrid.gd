extends Node2D

# TODO: Implement a ghost piece/placement preview piece. 
# TODO: Implement line clears and feeding data to be used for scoring. 
# TODO: Signal a Top out for gameover
# TODO: Implement the hard drop. 

signal active_piece_fixed
signal lines_cleared
signal game_over

var _block_dimensions: Vector2
var _grid_dimensions: Vector2
var _grid_contents
var _x_limit
var _y_limit
var _active_piece: Piece setget set_active_piece
var _input_hold_delta: float 
var _decent_speed: float setget set_decent_speed
var _soft_drop_speed: float
var _horizontal_movement_speed: float
var _vertical_movement_delta: float
var _horizontal_movement_delta: float
var _hold_input_threshold: float


var _block_instancing = preload("res://src/game_objects/block/Block.tscn")


##############################################
##############################################
func _ready():
	_block_dimensions = Vector2(30,30)
	_grid_dimensions = Vector2(10,22)
	_x_limit = _block_dimensions.x * (_grid_dimensions.x - 1)
	_y_limit = _block_dimensions.y * (_grid_dimensions.y - 1)
	_input_hold_delta = 0.0
	_decent_speed = 1
	_soft_drop_speed = 0.3
	_horizontal_movement_speed = 0.015
	_vertical_movement_delta = 0.0
	_horizontal_movement_delta = 0.0
	_hold_input_threshold = 0.18
	_grid_contents = []
	for column in range(_grid_dimensions.x):
		_grid_contents.append([])
		for _rows in range(_grid_dimensions.y):
			_grid_contents[column].append(null)


func _process(delta):
	_process_user_input(delta)
	_move_piece_down(delta)
	_update_projected_piece()


##############################################
##############################################
# setters and getters
func set_decent_speed(new_decent_speed: float) -> void:
	_decent_speed = new_decent_speed

func set_active_piece(new_active_piece) -> void:
	_active_piece = new_active_piece
	# Set position before adding child
	add_child(_active_piece)
	_set_spawn_position()

func pop_active_piece() -> Piece:
	remove_child(_active_piece)
	return _active_piece


func _set_spawn_position():
	if _active_piece is O_Piece:
		_active_piece.set_grid_position(Vector2(4, 0))
	else:
		_active_piece.set_grid_position(Vector2(3, 0))


func _process_user_input(delta):
	var piece_current_position = _active_piece.get_grid_position()
	var left_direction_vector = Vector2(-1, 0)
	var right_direction_vector = Vector2(1, 0)
	var down_direction_vector = Vector2(0,1)
	
	if Input.is_action_just_pressed("move_left"):
		if _can_piece_move_left():
			_move_piece_in_direction_using_vector(piece_current_position, left_direction_vector)
	if Input.is_action_just_pressed("move_right"):
		if _can_piece_move_right():
			_move_piece_in_direction_using_vector(piece_current_position, right_direction_vector)
	if Input.is_action_pressed("move_left"):
		if _can_piece_move_left():
			_process_held_movement_inputs(delta, piece_current_position, left_direction_vector)
	if Input.is_action_pressed("move_right"):
		if _can_piece_move_right():
			_process_held_movement_inputs(delta, piece_current_position, right_direction_vector)
	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right") or Input.is_action_just_released("soft_drop"):
		_input_hold_delta = 0
		_horizontal_movement_delta = 0
	if Input.is_action_pressed("soft_drop"):# and _input_hold_delta > _hold_input_threshold:
		if _can_piece_move_down():
			_process_held_movement_inputs(delta, piece_current_position, down_direction_vector)
		pass
	if Input.is_action_just_pressed("hard_drop"):
		pass
	if Input.is_action_just_pressed("rotate_right"):
		var current_orientation = _active_piece.get_current_piece_orientation()
		var target_orientation = _active_piece.get_current_piece_orientation() + 1
		if target_orientation >= GameEnums.PIECE_ORIENTATION.size():
			target_orientation = GameEnums.PIECE_ORIENTATION.ZERO_DEGREES
		var next_rotation = _active_piece.build_next_rotation_preview(GameEnums.ROTATION_DIRECTION.RIGHT)
		var rotation_test_result = _check_piece_rotation(current_orientation, target_orientation, next_rotation)
		if rotation_test_result[0]:
			var current_position = _active_piece.get_grid_position()
			var new_position = current_position + rotation_test_result[1]
			_active_piece.update_rotation_data(next_rotation, target_orientation, new_position)
		pass
	if Input.is_action_just_pressed("rotate_left"):
		var current_orientation = _active_piece.get_current_piece_orientation()
		var target_orientation = _active_piece.get_current_piece_orientation() - 1
		if target_orientation < 0:
			target_orientation = GameEnums.PIECE_ORIENTATION.TWOSEVENTY_DEGREES
		var next_rotation = _active_piece.build_next_rotation_preview(GameEnums.ROTATION_DIRECTION.LEFT)
		var rotation_test_result = _check_piece_rotation(current_orientation, target_orientation, next_rotation)
		if rotation_test_result[0]:
			var current_position = _active_piece.get_grid_position()
			var new_position = current_position + rotation_test_result[1]
			_active_piece.update_rotation_data(next_rotation, target_orientation, new_position)
		pass


func _move_piece_down(delta):
	_vertical_movement_delta += delta
	if _active_piece != null and _vertical_movement_delta > _decent_speed:
		_vertical_movement_delta = 0
		if _can_piece_move_down():
			var old_position_vector = _active_piece.get_grid_position()
			var new_position_vector = Vector2(old_position_vector.x, old_position_vector.y + 1)
			_active_piece.set_grid_position(new_position_vector)
			# TODO start the timer for allowing a piece to slide/rotate before becoming fully fixed
		else: 
			if _active_piece != null:
				_copy_active_piece_to_grid()
				
				emit_signal("active_piece_fixed")
	pass


func _copy_active_piece_to_grid():  
	var piece_final_position = _active_piece.get_grid_position()
	var piece_colour = _active_piece.get_colour()
	var matrix = _active_piece.get_current_rotation_matrix()
	var row_counter = 0
	while row_counter < matrix.size():
		var column_counter = 0
		while column_counter < matrix.size():
			if matrix[column_counter][row_counter] is Block:
				var resting_block = _block_instancing.instance()
				resting_block.set_block_colour(piece_colour)
				var new_block_position = Vector2(piece_final_position.x + column_counter, piece_final_position.y + row_counter)
				add_child(resting_block)
				resting_block.set_grid_position(new_block_position)
				_grid_contents[piece_final_position.x + column_counter][piece_final_position.y + row_counter] = resting_block
			column_counter += 1
		row_counter += 1


func _can_piece_move_down() -> bool:
	var piece_pos = _active_piece.get_grid_position()
	var rotation_collision_matrix = _active_piece.get_current_rotation_matrix().duplicate(true)
	var matrix_size = rotation_collision_matrix.size()
	
	var matrix_row_iterator = matrix_size - 1
	while matrix_row_iterator >= 0:
		var matrix_column_iterator = 0
		while matrix_column_iterator < matrix_size:	
			var matrix_item = rotation_collision_matrix[matrix_column_iterator][matrix_row_iterator]
			if matrix_item is Block:
				if piece_pos.y + matrix_row_iterator + 1 >= _grid_dimensions.y:
					return false
				else: 
					var grid_item = _grid_contents[piece_pos.x + matrix_column_iterator][piece_pos.y + matrix_row_iterator + 1]
					if grid_item is Block:
						return false
			matrix_column_iterator += 1
		matrix_row_iterator -= 1
	return true


func _can_piece_move_left() -> bool:
	var piece_pos = _active_piece.get_grid_position()
	var rotation_collision_matrix = _active_piece.get_current_rotation_matrix().duplicate(true)
	var matrix_size = rotation_collision_matrix.size()
	var matrix_column_iterator = 0
	
	while matrix_column_iterator < matrix_size:	
		var matrix_row_iterator = 0
		while matrix_row_iterator < matrix_size:
			var matrix_item = rotation_collision_matrix[matrix_column_iterator][matrix_row_iterator]
			if matrix_item is Block:
				if piece_pos.x + matrix_column_iterator - 1 < 0:
					return false
				else: 
					var grid_item = _grid_contents[piece_pos.x + matrix_column_iterator - 1][piece_pos.y + matrix_row_iterator]
					if grid_item is Block:
						return false
			matrix_row_iterator += 1
		matrix_column_iterator += 1
	return true


func _can_piece_move_right() -> bool: 
	var piece_pos = _active_piece.get_grid_position()
	var rotation_collision_matrix = _active_piece.get_current_rotation_matrix().duplicate(true)
	var matrix_size = rotation_collision_matrix.size()
	var matrix_column_iterator = matrix_size - 1
	
	while matrix_column_iterator >= 0:	
		var matrix_row_iterator = 0
		while matrix_row_iterator < matrix_size:
			var matrix_item = rotation_collision_matrix[matrix_column_iterator][matrix_row_iterator]
			if matrix_item is Block:
				if piece_pos.x + matrix_column_iterator + 1 >= _grid_dimensions.x:
					return false
				else: 
					var grid_item = _grid_contents[piece_pos.x + matrix_column_iterator + 1][piece_pos.y + matrix_row_iterator]
					if grid_item is Block:
						return false
			matrix_row_iterator += 1
		matrix_column_iterator -= 1
	return true


func _print_the_grid():
	var old_string_content = ""
	var logging_file = File.new()
	if logging_file.file_exists("res://logging.txt"):
		logging_file.open("res://logging.txt", File.READ_WRITE)
		old_string_content = logging_file.get_as_text()
	else: 
		logging_file.open("res://logging.txt", File.WRITE)
	var col_counter = 0
	logging_file.close()
	var new_string_content = ""
	logging_file.store_string("\n")
	logging_file.store_string("piece type: " + _active_piece.print_piece_details())
	new_string_content = new_string_content + "\n\rpiece type: " + _active_piece.print_piece_details()

	while col_counter < _grid_dimensions.y:
		var row_string = "\n"
		var row_counter = 0
		while row_counter < _grid_dimensions.x:
			var spacer = "\t"
			if _grid_contents[row_counter] [col_counter] == null:
				spacer = "\t\t\t"
			row_string = row_string + str(_grid_contents[row_counter] [col_counter]) + spacer
			row_counter += 1
		col_counter += 1
		new_string_content = new_string_content + row_string
		#print(row_string)
	var full_content = old_string_content + new_string_content
	# HACK: Remove the logging to the text file at some point. 
	logging_file.open("res://logging.txt", File.READ_WRITE)
	logging_file.store_string(full_content)
	logging_file.close()


func _update_projected_piece():
	pass


func _on_PlayGrid_active_piece_fixed():
	# Check for any line clears
	pass # Replace with function body.


func _process_held_movement_inputs(delta, piece_current_position, direction_vector):
	if _input_hold_delta > _hold_input_threshold:
		if _horizontal_movement_delta > _horizontal_movement_speed:
			_move_piece_in_direction_using_vector(piece_current_position, direction_vector)
			_horizontal_movement_delta = 0
		else:
			_horizontal_movement_delta += delta
	else:
		_input_hold_delta += delta


func _move_piece_in_direction_using_vector(piece_current_position, direction_vector): 
	var new_position = piece_current_position + direction_vector
	_active_piece.set_grid_position(new_position)


func _check_piece_rotation(current_orientation, target_orientation, rotation_collision_matrix_preview):
	var wall_kicks_dictionary = _active_piece.get_rotation_checks_dictionary().duplicate(true)
	var positions
	match current_orientation:
		GameEnums.PIECE_ORIENTATION.ZERO_DEGREES:
			if target_orientation == GameEnums.PIECE_ORIENTATION.NINTY_DEGREES:
				positions = wall_kicks_dictionary[GameEnums.PIECE_ROTATION_MOVEMENT.ZERO_TO_NINETY]
			elif target_orientation == GameEnums.PIECE_ORIENTATION.TWOSEVENTY_DEGREES:
				positions = wall_kicks_dictionary[GameEnums.PIECE_ROTATION_MOVEMENT.ZERO_TO_TWOHUNDREDSEVENTY]
			else: 
				return [false]
		GameEnums.PIECE_ORIENTATION.NINTY_DEGREES:
			if target_orientation == GameEnums.PIECE_ORIENTATION.ONEHUNDREDEIGHTY_DEGREES:
				positions = wall_kicks_dictionary[GameEnums.PIECE_ROTATION_MOVEMENT.NINETY_TO_ONEHUNDREDEIGHTY]
			elif target_orientation == GameEnums.PIECE_ORIENTATION.ZERO_DEGREES:
				positions = wall_kicks_dictionary[GameEnums.PIECE_ROTATION_MOVEMENT.NINETY_TO_ZERO]
			else: 
				return [false]
		GameEnums.PIECE_ORIENTATION.ONEHUNDREDEIGHTY_DEGREES:
			if target_orientation == GameEnums.PIECE_ORIENTATION.TWOSEVENTY_DEGREES:
				positions = wall_kicks_dictionary[GameEnums.PIECE_ROTATION_MOVEMENT.ONEHUNDREDEIGHTY_TO_TWOHUNDREDSEVENTY]
			elif target_orientation == GameEnums.PIECE_ORIENTATION.NINTY_DEGREES:
				positions = wall_kicks_dictionary[GameEnums.PIECE_ROTATION_MOVEMENT.ONEHUNDREDEIGHTY_TO_NINETY]
			else: 
				return [false]
		GameEnums.PIECE_ORIENTATION.TWOSEVENTY_DEGREES:
			if target_orientation == GameEnums.PIECE_ORIENTATION.ZERO_DEGREES:
				positions = wall_kicks_dictionary[GameEnums.PIECE_ROTATION_MOVEMENT.TWOHUNDREDSEVENTY_TO_ZERO]
			elif target_orientation == GameEnums.PIECE_ORIENTATION.ONEHUNDREDEIGHTY_DEGREES:
				positions = wall_kicks_dictionary[GameEnums.PIECE_ROTATION_MOVEMENT.TWOHUNDREDSEVENTY_TO_ONEHUNDREDEIGHTY]
			else: 
				return [false]
	for offset_position in positions:
		var result = _check_matrix_against_grid(offset_position, rotation_collision_matrix_preview)
		if result:
			return [true, offset_position]
	return [false]
	# perform the turn


func _check_matrix_against_grid(offset_vector2, collision_rotation_matrix):
	var limit = collision_rotation_matrix.size()
	var column = 0
	while column < limit: 
		var row = 0
		while row < limit:
			var matrix_item = collision_rotation_matrix[column][row]
			if matrix_item is Block:
				var item_check_position = _active_piece.get_grid_position() + offset_vector2 + Vector2(column, row)
				if item_check_position.x >= _grid_dimensions.x or item_check_position.x < 0 or item_check_position.y >= _grid_dimensions.y:
					return false
				else:
					var grid_item = _grid_contents[item_check_position.x][item_check_position.y]
					if grid_item is Block:
						return false
			row += 1
		column += 1
	return true

 
