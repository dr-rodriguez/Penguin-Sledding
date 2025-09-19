extends Control

@onready var main_buttons = $MainButtons
@onready var credits = $Credits
@onready var start_button = %StartButton
@onready var back_button = %BackToMain
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


func play_click_sound():
	audio_player.stream = Global.button_click_sound
	audio_player.play()


func _ready() -> void:
	credits.hide()
	main_buttons.show()
	start_button.grab_focus()


func _on_credits_pressed() -> void:
	play_click_sound()
	credits.show()
	main_buttons.hide()
	start_button.release_focus()
	back_button.grab_focus()


func _on_back_to_main_pressed() -> void:
	play_click_sound()
	credits.hide()
	main_buttons.show()
	back_button.release_focus()
	start_button.grab_focus()


func _on_quit_pressed() -> void:
	play_click_sound()
	get_tree().quit()


func _on_start_button_pressed() -> void:
	play_click_sound()
	SceneTransition.load_scene("res://scenes/main/main.tscn")
	#get_tree().change_scene_to_file("res://scenes/main/main.tscn")
