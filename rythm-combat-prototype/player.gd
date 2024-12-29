extends CharacterBody2D


const SPEED := 400.0
const JUMP_VELOCITY := -800.0
var hold_jump = false # Jump input buffer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		#velocity.y += 980 * delta
		velocity += get_gravity() * 1.45 * delta
	
	# Handle jump.
	if (Input.is_action_pressed("w") or (hold_jump and not $JumpTimer.is_stopped())) and is_on_floor():
		velocity.y += JUMP_VELOCITY
		hold_jump = false
		$JumpTimer.stop()
	elif Input.is_action_pressed("w"):
		hold_jump = true
		$JumpTimer.start()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("a", "d")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	# Update animation
	if velocity.normalized() == Vector2(0, 0):
		$AnimatedSprite2D.animation = "idle"
	elif velocity.normalized().x > 0:
		$AnimatedSprite2D.animation = "right"
	elif velocity.normalized().x < 0:
		$AnimatedSprite2D.animation = "left"
	elif velocity.normalized().y > 0:
		$AnimatedSprite2D.animation = "down"
	elif velocity.normalized().y < 0:
		$AnimatedSprite2D.animation = "up"
	
