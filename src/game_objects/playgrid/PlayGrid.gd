extends Node2D


signal active_piece_fixed
signal lines_cleared
signal game_over

var _block_dimensions: Vector2
var _grid_dimensions: Vector2
var _grid_contents
var _x_limit
var _y_limit
var _active_piece: Tetromino setget set_active_piece
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
	_decent_speed = 0.1
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


func _set_spawn_position():
	if _active_piece is O_Piece:
		_active_piece.set_grid_position(Vector2(4, 0))
	else:
		_active_piece.set_grid_position(Vector2(3, 0))


func _process_user_input(delta):
	var piece_current_position = _active_piece.get_grid_position()
	var left_direction_vector = Vector2(-1, 0)
	var right_direction_vector = Vector2(1, 0)
	
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
	if Input.is_action_pressed("soft_drop") and _input_hold_delta > _hold_input_threshold:
		pass
	if Input.is_action_just_pressed("hard_drop"):
		pass
	if Input.is_action_just_pressed("rotate_right"):
		pass
	if Input.is_action_just_pressed("rotate_left"):
		pass


func _move_piece_down(delta):
	_vertical_movement_delta += delta
	# TODO need a better way to alter the speed etc. 
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
	#_print_the_grid()


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
