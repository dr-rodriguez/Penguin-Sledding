extends Area2D

@export var tree_scene: PackedScene
@export var rock_scene: PackedScene
@onready var spawn_area = %SpawnArea
const MAX_TREES = 3
const MAX_ROCKS = 1


func _ready() -> void:
	# Spawn a full set of trees at the start of the game
	for _i in range(MAX_TREES):
		spawn_obstacles(tree_scene)
	for _i in range(MAX_ROCKS):
		spawn_obstacles(rock_scene)


func spawn_obstacles(scene_object) -> void:
	# Get the collision shape of the spawner area to find its size
	var spawn_pos = global_position
	var spawner_shape = spawn_area.shape as RectangleShape2D
	
	# Calculate the boundaries of the spawner rectangle
	var min_x = spawn_pos.x - spawner_shape.size.x / 2.0
	var max_x = spawn_pos.x + spawner_shape.size.x / 2.0
	var min_y = spawn_pos.y - spawner_shape.size.y / 2.0
	var max_y = spawn_pos.y + spawner_shape.size.y / 2.0
	
	# Generate a random position within the spawner's bounds
	var spawn_pos_x = randf_range(min_x, max_x)
	var spawn_pos_y = randf_range(min_y, max_y)
	var new_obstacle = scene_object.instantiate()
	new_obstacle.global_position = Vector2(spawn_pos_x, spawn_pos_y)
	
	#print(spawn_pos)
	#print(spawner_shape.get_size())
	#print(min_x, " ", max_x, " ", min_y, " ", max_y)
	#print(spawn_pos_x, " ", spawn_pos_y)
	
	# Add the new obstacle to the scene. This is a child of the top scene
	get_tree().current_scene.add_child.call_deferred(new_obstacle)


func check_and_make_obstacles(ignore_max: bool = false):
	# Helper function to check the obstacles in the area and spawn up to the max
	
	# Get any instance of a tree to remove
	var trees = get_tree().get_nodes_in_group("Trees")
	var current_trees = trees.size()
	var rocks = get_tree().get_nodes_in_group("Rocks")
	var current_rocks = rocks.size()
	var obstacles = get_tree().get_nodes_in_group("Obstacles")
	if obstacles.size() > (MAX_ROCKS + MAX_TREES) * 2:
		return
	
	if current_trees < MAX_TREES:
		for _i in range(MAX_TREES-current_trees):
			spawn_obstacles(tree_scene)
	elif current_trees >= MAX_TREES and ignore_max:
		spawn_obstacles(tree_scene)
		
	if current_rocks < MAX_ROCKS:
		for _i in range(MAX_ROCKS-current_rocks):
			spawn_obstacles(rock_scene)
	elif current_rocks >= MAX_ROCKS and ignore_max:
		spawn_obstacles(rock_scene)


#func _on_tree_timer_timeout() -> void:
	## Timer-based check in case the body_exit isn't called proper (eg, horizontal motion)
	#check_and_make_obstacles()


func _on_despawn_obstacle_removed() -> void:
	check_and_make_obstacles(true)
