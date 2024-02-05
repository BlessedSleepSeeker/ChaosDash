extends Control

@export var creditsScenePath := "res://scenes/Menu/CreditsScene.tscn"
@export var gameSettingPath := "res://scenes/Menu/settings/StartGameSettings.tscn"
@export var settings_screen_path := "res://scenes/Menu/settings/settings_screen.tscn"

signal transition(new_scene: PackedScene, with_animation: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	var creditsScene = load(creditsScenePath)
	transition.emit(creditsScene, true)

func _on_play_button_pressed():
	var gameScene = load(gameSettingPath)
	transition.emit(gameScene, true)

func _on_settings_pressed():
	var settings_scene = load(settings_screen_path)
	transition.emit(settings_scene, true)
