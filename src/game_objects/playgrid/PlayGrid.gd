extends Node2D


signal active_piece_fixed
signal line_cleared

var _block_dimensions: Vector2
var _grid_dimensions: Vector2
var _grid_contents
var _x_limit
var _y_limit
var _active_piece: Tetromino setget set_active_piece
var _decent_speed: float setget set_decent_speed
var _movement_delta


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
	for column in range(_grid_dimensions.x):
		_grid_contents.append([])
		for _rows in range(_grid_dimensions.y):
			_grid_contents[column].append(null)


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
	_active_piece = new_active_piece
	# Set position before adding child
	add_child(_active_piece)
	_set_spawn_position()


func _set_spawn_position():
	if _active_piece is O_Piece:
		_active_piece.set_grid_position(Vector2(4, 0))
	else:
		_active_piece.set_grid_position(Vector2(3, 0))


func _move_piece_down(delta):
	_movement_delta += delta
	# TODO need a better way to alter the speed etc. 
	if _active_piece != null and _movement_delta > 0.1:
		_movement_delta = 0
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
	var col_counter = 0
	while col_counter < matrix.size():
		var row_counter = 0
		while row_counter < matrix.size():
			if matrix[row_counter][col_counter] is Block:
				var resting_block = _block_instancing.instance()
				resting_block.set_block_colour(piece_colour)
				var new_block_position = Vector2(piece_final_position.x + col_counter, piece_final_position.y + row_counter)
				add_child(resting_block)
				resting_block.set_grid_position(new_block_position)
				_grid_contents[piece_final_position.x + col_counter][piece_final_position.y + row_counter] = resting_block
			row_counter += 1
		col_counter += 1
	#_print_the_grid()


func _can_piece_move_down() -> bool:
	var piece_pos = _active_piece.get_grid_position()
	var piece_rotation_collision_matrix_size = _active_piece.get_current_rotation_matrix().size()
	var lowest_matrix_collision_row = _active_piece.get_lowest_collision_row()
	
	if (piece_pos.y + lowest_matrix_collision_row) == (_grid_dimensions.y - 1):
		return false
	elif (piece_pos.y + lowest_matrix_collision_row) < (_grid_dimensions.y - 1):
		var matrix_column_iterator = 0
		while matrix_column_iterator < piece_rotation_collision_matrix_size:
			var next_grid_item = _grid_contents[piece_pos.x + matrix_column_iterator][piece_pos.y + lowest_matrix_collision_row + 1]
			if next_grid_item is Block:
				return false
			matrix_column_iterator += 1
		return true
	else:
		return false


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
