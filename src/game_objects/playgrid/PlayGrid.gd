extends Node2D


var _block_dimensions: Vector2
var _grid_dimensions: Vector2
var _grid_contents
var _active_piece setget set_active_piece
var _decent_speed: float setget set_decent_speed


func _ready():
	_block_dimensions = Vector2(30,30)
	_grid_dimensions = Vector2(10,22)
	_grid_contents = []


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
	pass


# setters and getters
func set_decent_speed(new_decent_speed: float) -> void:
	_decent_speed = new_decent_speed

func set_active_piece(new_active_piece) -> void:
	if _active_piece != null:
		remove_child(_active_piece)
	_active_piece = new_active_piece
	# Set position before adding child
	_set_spawn_position()
	add_child(_active_piece)


func _set_spawn_position():
	var x
	var y
	if _active_piece is I_Piece:
		print("I piece check 2")
		x = (_active_piece.get_offsets().x * -1) + 60
		y = (_active_piece.get_offsets().y -1) + 60
	if _active_piece is J_Piece:
		print("J piece check 2")
		x = (_active_piece.get_offsets().x * -1) + 90
		y = (_active_piece.get_offsets().y -1) + 90
	if _active_piece is L_Piece:
		print("L piece check 2")
		x = (_active_piece.get_offsets().x * -1) + 90
		y = (_active_piece.get_offsets().y -1) + 90
	if _active_piece is O_Piece:
		print("O piece check 2")
		x = (_active_piece.get_offsets().x * -1) + 90
		y = (_active_piece.get_offsets().y -1) + 90
	if _active_piece is S_Piece:
		print("S piece check 2")
		x = (_active_piece.get_offsets().x * -1) + 90
		y = (_active_piece.get_offsets().y -1) + 90
	if _active_piece is T_Piece:
		print("T piece check 2")
		x = (_active_piece.get_offsets().x * -1) + 90
		y = (_active_piece.get_offsets().y -1) + 90
	if _active_piece is Z_Piece:
		print("Z piece check 2")
		x = (_active_piece.get_offsets().x * -1) + 90
		y = (_active_piece.get_offsets().y -1) + 90
	_active_piece.position = Vector2(x,y)
