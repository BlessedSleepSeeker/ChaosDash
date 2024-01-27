extends CenterContainer

@export var creditsScenePath := "res://Scenes/Menu/CreditsScene.tscn"
@export var gameScenePath := "res://Scenes/World/World.tscn"

@onready var playBtn = $VBox/Play
@onready var creditsBtn = $VBox/Credits
@onready var quitBtn = $VBox/Exit
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	var creditsScene = load(creditsScenePath)
	get_tree().change_scene_to_packed(creditsScene)

func _on_play_button_pressed():
	var gameScene = load(gameScenePath)
	get_tree().change_scene_to_packed(gameScene)
