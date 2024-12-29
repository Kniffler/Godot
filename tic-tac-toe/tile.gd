extends AnimatedSprite2D

signal request_assignment
var ID: int = 0
var setting = "idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.set_self_modulate(Color(0, 0, 0, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play(setting)

func get_setting():
	return setting

func _on_button_pressed():
	request_assignment.emit(ID)

func clear_settings():
	setting = "idle"
	$Button.disabled = false

# Set the ID for this tile, should only be called ONCE
func set_ID(new_ID: int):
	ID = new_ID

# Asigns the new value to the tile
func asign_tile(to: String):
	play(to)
	setting = to
	$Button.disabled = true
