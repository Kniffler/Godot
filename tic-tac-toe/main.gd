extends Node

@export var tile_scene : PackedScene
var turn := true # o starts
var turn_count: int = 1
var current
var tiles = []
var favour 
var do_not_favour


# Called when the node enters the scene tree for the first time.
func _ready():
	if(turn):
		current = "o"
	else:
		current = "x"
	
	$HUD/Hint.text = current + " starts*"
	for i in range(3):
		for k in range(3):
			var new_tile = tile_scene.instantiate()
			new_tile.position = Vector2(k*165 + 75, i*165 + 75)
			new_tile.set_ID(tiles.size())
			tiles.append(new_tile)
			add_child(new_tile)
			new_tile.request_assignment.connect(update_tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("o_cheat"):
		favour = "o"
		do_not_favour = "x"
	elif Input.is_action_pressed("x_cheat"):
		favour = "x"
		do_not_favour = "o"

# Updates the turn, switches from x to o and vice-versa
func update_turn():
	turn = not turn
	if(turn):
		current = "o"
	else:
		current = "x"
	turn_count += 1

# Updates a given tile, called on request_assignment signal from every tile along with its ID
func update_tile(ID):
	tiles[ID].asign_tile(current)
	print("Got a signal from tile " + str(ID) + " -> " + current)
	update_turn()
	if turn_count > 5:
		check_4_win_case()

func reset_tiles():
	for tile in tiles:
		tile.hide()
		tile.clear_settings()

func new_game():
	$HUD.hide()
	for tile in tiles:
		tile.show()

func check_4_win_case():
	var t: Array
	for i in range(9):
		t.append(tiles[i].get_setting())
	if t[0] == t[1] && t[1] == t[2] && t[0] != "idle":
		decide_winner(t[0] + " wins!")
	elif t[3] == t[4] && t[4] == t[5] && t[3] != "idle":
		decide_winner(t[3] + " wins!")
	elif t[6] == t[7] && t[7] == t[8] && t[6] != "idle":
		decide_winner(t[6] + " wins!")
	elif t[0] == t[3] && t[3] == t[6] && t[0] != "idle":
		decide_winner(t[0] + " wins!")
	elif t[1] == t[4] && t[4] == t[7] && t[1] != "idle":
		decide_winner(t[1] + " wins!")
	elif t[2] == t[5] && t[5] == t[8] && t[2] != "idle":
		decide_winner(t[2] + " wins!")
	elif t[0] == t[4] && t[4] == t[8] && t[0] != "idle":
		decide_winner(t[0] + " wins!")
	elif t[2] == t[4] && t[4] == t[6] && t[2] != "idle":
		decide_winner(t[2] + " wins!")
	elif t[0] != "idle" && t[1] != "idle" && t[2] != "idle" && t[3] != "idle" && t[4] != "idle" && t[5] != "idle" && t[6] != "idle" && t[7] != "idle" && t[8] != "idle":
		decide_winner("It's a draw!")
	
func decide_winner(win_str: String):
	
	$HUD/ClickMeButton.hide()
	$HUD/Hint.hide()
	if favour != win_str[0] && favour != null:
		for tile in tiles:
			if tile.get_setting() == favour && win_str[0] != 'I':
				tile.clear_settings()
				tile.asign_tile(do_not_favour)
			elif tile.get_setting() == do_not_favour || win_str[0] == 'I':
				tile.clear_settings()
				tile.asign_tile(favour)
		win_str = favour + " wins!"
	await get_tree().create_timer(0.85).timeout
	reset_tiles()
	if turn_count % 2 == 0:
		update_turn()
	$HUD/GameNameAndMsg.text = win_str
	$HUD.show()
	await get_tree().create_timer(1.75).timeout
	$HUD/Hint.show()
	$HUD/GameNameAndMsg.text = "Welcome to Lume's Tic-Tac-Toe"
