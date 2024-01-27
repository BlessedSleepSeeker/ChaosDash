extends MarginContainer

@onready var animSprite = $HBoxContainer/CenterContainer/TextuAnimatedSprite2D
@onready var playerNbr = $HBoxContainer/VBox/PlayerNbr
@onready var playerScore = $HBoxContainer/VBox/PlayerScore

@export var playerStr = "Player %d"
@export var playerScoreStr = "%d Points"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateNbr(nbr: int) -> void:
	playerNbr.text = playerStr % nbr

func updateScore(nbr: int) -> void:
	playerScore.text = playerScoreStr % nbr
	animSprite.play()