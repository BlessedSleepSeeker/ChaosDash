class_name WorldHandler
extends Node

@onready var levelHandler: LevelHandler = $SplitScreenHandler/MainSubview/SubViewport/LevelHandler
@onready var splitscreenHandler: SplitScreenHandler = $SplitScreenHandler
@onready var chaosHandler: ChaosHandler = $ChaosHandler

@export var difficulty: int = 0

var levelTransition: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	levelHandler.level_finished.connect(_on_level_finished)
	levelHandler.level_started.connect(_on_level_started)
	levelHandler.player_death.connect(_on_player_death)
	setUpLevel(difficulty)

func setUpLevel(_lvlDifficulty: int) -> void:
	levelHandler.loadLevel(self.difficulty)
	splitscreenHandler.setPlayerToStart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if levelTransition:
		levelTransition = !levelTransition
		levelHandler.unloadLevel()
		setUpLevel(difficulty)

func _on_level_finished(_body: Node2D):
	if _body is Player:
		print(_body.PLAYER_NBR)
	levelTransition = true
	if self.difficulty == 0:
		self.difficulty += 1
	

func _on_level_started():
	pass

func _on_player_death(_body: Node2D):
	_body.position = levelHandler.getLevelStartingPos()
