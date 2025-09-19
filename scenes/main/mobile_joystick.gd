extends Area2D

@export var max_radius = 50.0

@onready var thumbstick = %Thumbstick
var is_touching = false
var touch_start_pos = Vector2.ZERO

signal joystick_moved(direction_vector)


func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	print(event)
	if event is InputEventScreenTouch:
		if event.is_pressed():
			# Store the starting touch position
			is_touching = true
			touch_start_pos = event.position
		else:
			# Touch released, reset everything
			is_touching = false
			thumbstick.position = Vector2.ZERO
			emit_signal("joystick_moved", Vector2.ZERO)

	if event is InputEventScreenDrag and is_touching:
		# Get the vector from the touch start to the current position
		var drag_vector = event.position - touch_start_pos
		
		# Clamp the thumbstick's position to the max_radius
		if drag_vector.length() > max_radius:
			drag_vector = drag_vector.normalized() * max_radius
		
		# Move the thumbstick visually
		thumbstick.position = drag_vector
		
		# Emit a signal with the normalized direction vector
		emit_signal("joystick_moved", drag_vector.normalized())
