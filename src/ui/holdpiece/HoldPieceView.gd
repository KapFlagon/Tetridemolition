extends PanelContainer


var _last_held_piece
var _current_held_piece setget swap_current_held_piece, get_current_held_piece


func swap_current_held_piece(new_current_held_piece):
	if (_last_held_piece == null) or (_last_held_piece != new_current_held_piece):
		remove_child(_current_held_piece)
		_last_held_piece = _current_held_piece
		_current_held_piece = new_current_held_piece
		_update_positions()
		add_child(_current_held_piece)
		return _last_held_piece

func get_current_held_piece():
	return _current_held_piece


func _update_positions() -> void:
	_current_held_piece.position.x = 90
	_current_held_piece.position.y = 90


func swap_permitted(new_current_held_piece) -> bool:
	if (_last_held_piece == null) or (_last_held_piece != new_current_held_piece):
		return true
	else: 
		return false
