extends Node2D

@onready var player = %Player
@onready var bgmusic = %BackgroundMusic
@onready var score_label = %Score
@onready var instruction1 = %Instruction1
# Using a plugin for Touch Screen Joystick
@onready var joystick_node = %TouchScreenJoystick 
# Cloud variables
@export var cloud_scene: PackedScene
@onready var cloud_spawn_location = %CloudPathLocation
var cloud_speed: float = 100.
# Health variables
@onready var health = %Health
@export var health_scene: PackedScene


func _ready() -> void:
	# Score preparation
	Global.score = 0
	score_label.show()
	
	# Player health preparation
	prepare_health()

	# Check if the game is running on an Android or iOS device
	var is_mobile = OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios")

	if not is_mobile:
		# If not on mobile, hide the joystick nodes
		if joystick_node:
			joystick_node.hide()
	# Change instruction text
	if is_mobile:
		instruction1.text = "Use on-screen Joystick to move"


func prepare_health():
	var max_health = Global.max_health

	# Clear any existing hearts
	for child in health.get_children():
		child.queue_free()

	# Dynamically create hearts based on max_health
	for i in range(max_health):
		var new_heart = health_scene.instantiate()
		health.add_child(new_heart)
		new_heart.custom_minimum_size.x = 32
		new_heart.size_flags_vertical = Control.SIZE_SHRINK_CENTER


func get_health_by_index(index: int):
	# Check if the index is valid
	if index >= 0 and index < health.get_child_count():
		return health.get_child(index)
	return null


func handle_health() -> void:
	# Function to handle health and token display
	Global.player_health -= 1
	
	# Change the icon
	var health_token = get_health_by_index(Global.player_health)
	if health_token:
		var anim = health_token.get_node("AnimatedSprite2D")
		anim.play("empty")


func game_over():
	bgmusic.stop()
	joystick_node.reset_actions()
	joystick_node.reset_knob()
	score_label.hide()
	player.queue_free()
	# Not using transition so the game over is more immediate
	# Also, this avoids some errors with player disappearing
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over/game_over.tscn")


func _on_score_timer_timeout() -> void:
	# Update the score on every time tick
	if player:
		if player.velocity.y > 0:
			Global.score += player.velocity.y/player.PLAYER_SPEED
			score_label.text = "Score: " + str(Global.score)


func _on_player_player_hit() -> void:
	# Player takes some damage
	handle_health()
	
	# Player is hit enough times, game over
	if Global.player_health <= 0:
		await player.anim.animation_finished
		game_over()


func _on_cloud_timer_timeout() -> void:
	# Get a random location for the cloud
	cloud_spawn_location.progress_ratio = randf()
	
	# Create a cloud object at a random location on the path bounding the scene
	var cloud = cloud_scene.instantiate()
	add_child(cloud)
	cloud.global_position = cloud_spawn_location.global_position
	
	# Scale the size
	var cloud_sprite = cloud.get_node("CloudSprite")
	var random_scale = randf_range(1.0, 3.0)
	cloud_sprite.scale = Vector2(random_scale, random_scale)
	
	# Change the color and opacity
	var grey_value: float = randf_range(0.3, 0.6)
	cloud_sprite.modulate = Color(grey_value, grey_value, grey_value)
	cloud_sprite.modulate.a = randf_range(0.3, 0.6)
	
	# Velocity of cloud
	var velocity = Vector2(randf_range(0.5, 1.5) * cloud_speed, 0.)
	cloud.linear_velocity = velocity
