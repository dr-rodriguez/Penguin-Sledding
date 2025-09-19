extends Control

@onready var game_over_label = %GOScoreLabel
@onready var game_over_music = $GameOverSound
@onready var back_button =%RetryButton
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


func play_click_sound():
	audio_player.stream = Global.button_click_sound
	audio_player.play()


func _ready() -> void:
	game_over_music.play()
	game_over_label.text = "Final Score: " + str(Global.score)
	back_button.grab_focus()


func _on_retry_button_pressed() -> void:
	play_click_sound()
	SceneTransition.load_scene("res://scenes/title/title_screen.tscn")
	#get_tree().change_scene_to_file("res://scenes/title/title_screen.tscn")
