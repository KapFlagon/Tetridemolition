extends PanelContainer


# array of three pieces, with setter
var pieces = []



func _ready():
	pass 


# Setter should have a signal, possibly? 
# When setter gets new array of pieces, add them to the scene 
# and position them relative to the top of the UI, taking the
# array index into account as a mulitplier of distance. 


func add_initial_preview_pieces(new_pieces_array) -> void:
	pieces.append_array(new_pieces_array)
	for piece in new_pieces_array:
		add_child(piece)
	_update_all_positions()


func add_new_preview_piece(new_piece):
	var old_piece = pieces.pop_front()
	pieces.append(new_piece)
	remove_child(old_piece)
	add_child(new_piece)
	_update_all_positions()


func _update_all_positions() -> void:
	var iterator = 0
	while iterator < pieces.size():
		pieces[iterator].position.x = 90
		pieces[iterator].position.y = 90 + (90 * iterator)
		# TODO need to adjust positions better
		iterator += 1
