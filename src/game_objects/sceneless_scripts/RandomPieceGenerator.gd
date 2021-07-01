extends Node


class_name RandomPieceGenerator

var i_piece_scene = preload("res://src/game_objects/pieces/i_piece/I_Piece.tscn")
var j_piece_scene = preload("res://src/game_objects/pieces/j_piece/J_Piece.tscn")
var l_piece_scene = preload("res://src/game_objects/pieces/L_piece/L_Piece.tscn")
var o_piece_scene = preload("res://src/game_objects/pieces/o_piece/O_Piece.tscn")
var s_piece_scene = preload("res://src/game_objects/pieces/s_piece/S_Piece.tscn")
var t_piece_scene = preload("res://src/game_objects/pieces/t_piece/T_Piece.tscn")
var z_piece_scene = preload("res://src/game_objects/pieces/z_piece/Z_Piece.tscn")

var _piece_container_a = []
var _piece_container_b = []
var _active_container


enum _E_Containers {CONTAINER_A, CONTAINER_B}


func _ready():
	pass
	
func _init():
	_fill_container(_piece_container_a)
	_fill_container(_piece_container_b)
	_active_container = _E_Containers.CONTAINER_A


func preview_next_three_pieces():
	match _active_container:
		_E_Containers.CONTAINER_A:
			if _piece_container_a.size() >= 3:
				return _peek_from_single_container(_piece_container_a)
			else: 
				return _peek_from_two_containers(_piece_container_a, _piece_container_b)
		_E_Containers.CONTAINER_B:
			if _piece_container_b.size() >= 3:
				return _peek_from_single_container(_piece_container_b)
			else: 
				return _peek_from_two_containers(_piece_container_b, _piece_container_a)


func _peek_from_single_container(piece_container):
	var three_pieces = []
	three_pieces = _peek_amount_of_pieces(piece_container, 3)
	return three_pieces


func _peek_from_two_containers(main_container, secondary_container):
	var three_pieces = []
	var primary_pieces = _peek_amount_of_pieces(main_container, main_container.size())
	three_pieces.append_array(primary_pieces)
	var remainder = 3 - three_pieces.size()
	var secondary_pieces = _peek_amount_of_pieces(secondary_container, remainder)
	three_pieces.append_array(secondary_pieces)
	return three_pieces


func _peek_amount_of_pieces(piece_container, amount_to_peek):
	var pieces = []
	var counter = 0
	while counter < amount_to_peek:
		var item_position = piece_container.size() - 1 - counter
		pieces.append(piece_container[item_position])
		counter +=1
	return pieces
	

func preview_next_piece():
	var three_pieces = preview_next_three_pieces()
	return three_pieces[2]


func pop_next_piece():
	var next_piece
	match _active_container:
		_E_Containers.CONTAINER_A:
			next_piece = _piece_container_a.pop_back()
			if _piece_container_a.size() < 1:
				_active_container = _E_Containers.CONTAINER_B
				_fill_container(_piece_container_a)
		_E_Containers.CONTAINER_B:
			next_piece = _piece_container_b.pop_back()
			if _piece_container_b.size() < 1:
				_active_container = _E_Containers.CONTAINER_A
				_fill_container(_piece_container_b)
	return next_piece


func _fill_container(container_array) -> void:
	container_array.append(i_piece_scene.instance())
	container_array.append(j_piece_scene.instance())
	container_array.append(l_piece_scene.instance())
	container_array.append(o_piece_scene.instance())
	container_array.append(s_piece_scene.instance())
	container_array.append(t_piece_scene.instance())
	container_array.append(z_piece_scene.instance())
	randomize()
	container_array.shuffle()

