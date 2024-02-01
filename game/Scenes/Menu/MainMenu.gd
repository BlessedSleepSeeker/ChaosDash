extends CenterContainer

@export var creditsScenePath := "res://scenes/Menu/CreditsScene.tscn"
@export var gameSettingPath := "res://scenes/Menu/settings/StartGameSettings.tscn"

@onready var playBtn = $VBox/Play
@onready var creditsBtn = $VBox/Credits
@onready var quitBtn = $VBox/Exit

signal transition(new_scene: PackedScene)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	var creditsScene = load(creditsScenePath)
	transition.emit(creditsScene)

func _on_play_button_pressed():
	var gameScene = load(gameSettingPath)
	transition.emit(gameScene)

func _on_settings_pressed():
	pass # Replace with function body.
