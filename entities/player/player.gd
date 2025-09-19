extends CharacterBody2D

@export var hit_sounds: Array[AudioStream]
@onready var anim = $AnimatedSprite2D
@onready var hurt_hearts = $GPUParticles2D
const PLAYER_SPEED: float = 200.0
const MAX_SPEED: float = 1000.0
var direction = Vector2.ZERO

signal player_hit


func _ready() -> void:
	# Set the default animaion to be left and stop it
	anim.animation = "left"
	anim.frame = 0
	anim.stop()
	Global.player_health = Global.max_health


func moving_logic(delta) -> void:
	# All the logic for handling the player movement, animations, etc
	# Handle horizontal movement and deceleration
	if direction.x != 0:
		# Set the horizontal velocity directly if there is input
		velocity.x = direction.x * PLAYER_SPEED
	else:
		# Gradually slow down the horizontal velocity to 0
		velocity.x = move_toward(velocity.x, 0, PLAYER_SPEED * delta)
	
	# Handle vertical velocity and deceleration
	if direction.y < 0:
		# Moving up is harder
		velocity.y = direction.y * PLAYER_SPEED / 2.0
	elif direction.y > 0:
		# Moving down is just accelerating by the speed
		velocity.y += PLAYER_SPEED * delta
		# Clamp the velocity to prevent infinite acceleration
		velocity.y = min(velocity.y, MAX_SPEED)
	else:
		# If no vertical input, gradually slow down the vertical drift
		velocity.y = move_toward(velocity.y, 0, PLAYER_SPEED * delta)
	
	# Animations/sprites
	if direction.x < 0:
		anim.animation = "left"
	elif direction.x > 0:
		anim.animation = "right"
	
	# Only animate if a key is being pressed
	if direction.length() > 0:
		anim.play()
	else:
		anim.stop()
	
	# Actually move
	move_and_slide()  # delta is implied here


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	moving_logic(delta)


func play_random_hit_sound():
	if hit_sounds.size() > 0:
		# Get a random sound from the array
		var random_index = randi() % hit_sounds.size()
		var random_sound = hit_sounds[random_index]
		
		# Get your AudioStreamPlayer2D node
		var audio_player = $AudioStreamPlayer

		# Assign the selected sound and play it
		audio_player.stream = random_sound
		audio_player.play()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	# Check if it's an obstacle that the player has hit
	if body.is_in_group("Obstacles"):
		# Change animation
		var hit_anims = ["hit_left", "hit_right"]
		if direction.x < 0 or velocity.x < 0:
			anim.animation = hit_anims[0]
		elif direction.x > 0 or velocity.x > 0:
			anim.animation = hit_anims[1]
		else:
			anim.animation = hit_anims[randi_range(0, 1)]
		anim.play()
		
		# Play hurt effect
		hurt_hearts.restart()
		play_random_hit_sound()
		
		# Signal to manage game over
		emit_signal("player_hit")
