extends Area2D

signal obstacle_removed


func _on_area_entered(area: Area2D) -> void:
	# Check if the entered area belongs to a tree
	if area.get_parent().is_in_group("Obstacles") or area.get_parent().is_in_group("Clouds"):
		area.get_parent().queue_free()
		emit_signal("obstacle_removed")
