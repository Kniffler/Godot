extends CanvasLayer

signal start_game
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass

func signal_game_start():
	start_game.emit()

func show_favour():
	$StartButton.hide()
	$Hint.hide()
	$GameNameAndMsg.text = "Press o for o to always win\nPress x for x to always win"
	$GameNameAndMsg.add_theme_font_size_override("font_size", 32)
	$FavourTimer.start()
	await $FavourTimer.timeout
	$GameNameAndMsg.text = "Welcome to Lume's Tic-Tac-Toe"
	$GameNameAndMsg.add_theme_font_size_override("font_size", 64)
	$StartButton.show()
	$Hint.show()
	
