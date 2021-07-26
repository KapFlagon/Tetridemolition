extends Node2D


var _random_piece_generator: RandomPieceGenerator
var _active_piece: Piece
onready var _piece_preview =  get_node("UI/PiecePreview")
onready var _hold_piece_view = get_node("UI/HoldPieceView")
onready var _playgrid = get_node("PlayGrid")


func _ready():
	_random_piece_generator = RandomPieceGenerator.new()
	_piece_preview.add_initial_preview_pieces(_random_piece_generator.preview_next_three_pieces())
	_active_piece = _random_piece_generator.pop_next_piece()
	_piece_preview.add_new_preview_piece(_random_piece_generator.preview_next_piece())
	_playgrid.connect("ready_for_next_piece",self,"_get_next_piece")
	_get_next_piece()
	pass


func _process(delta):
	if Input.is_action_just_pressed("hold_piece"):
		_hold_piece()
	if Input.is_action_just_pressed("pause_game"):
		pass


func _get_next_piece():
	_active_piece = _random_piece_generator.pop_next_piece()
	_piece_preview.add_new_preview_piece(_random_piece_generator.preview_next_piece())
	_playgrid.set_active_piece(_active_piece)


func _hold_piece():
	if _hold_piece_view.swap_permitted(_active_piece):
			var test = _playgrid.pop_active_piece()
			var swapped_piece = _hold_piece_view.swap_current_held_piece(_active_piece)
			if swapped_piece == null:
				_get_next_piece()
			else:
				_active_piece = swapped_piece
				_playgrid.set_active_piece(_active_piece)


func _on_PlayGrid_top_out_detected():
	_playgrid._grid_active = false
	print("game over")
