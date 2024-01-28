extends CenterContainer

@export var gameScenePath := "res://scenes/game_world/World.tscn"
@onready var lbl: Label = $VB/HB/PlayerNbr

const lblTxt: String = "%d Player(s)"

@export var playerCount = 2:
	set(val):
		playerCount = val
		lbl.text = lblTxt % playerCount

func _ready():
	playerCount = 2

func _on_up_button_pressed():
	playerCount += 1


func _on_down_button_pressed():
	playerCount -= 1


func _on_button_pressed():
	var gameScene = load(gameScenePath).instantiate()
	gameScene.playerCount = playerCount
	get_tree().root.add_child(gameScene)
	queue_free()
