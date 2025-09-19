extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer


func _ready() -> void:
	color_rect.hide()


func load_scene(target_scene: String):
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().call_deferred("change_scene_to_file", target_scene)
	#get_tree().change_scene_to_file(target_scene)
	animation_player.play_backwards("Fade")


func reload_scene():
	animation_player.play("Fade")
	await animation_player.animation_finished
	#get_tree().reload_current_scene()
	get_tree().call_deferred("reload_current_scene")
	animation_player.play_backwards("Fade")
