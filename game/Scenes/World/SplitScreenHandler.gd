class_name SplitScreenHandler
extends GridContainer

@export var playerViewport = preload("res://Scenes/World/PlayerViewport.tscn")
@onready var mainSubviewport: SubViewportContainer = $MainSubview
@onready var mainView: SubViewport = $MainSubview/SubViewport
@onready var levelHandler: LevelHandler = $MainSubview/SubViewport/LevelHandler

@export var player_nbr = 2

@onready var players: Array = [$MainSubview/SubViewport/Player1]

# Called when the node enters the scene tree for the first time.
func _ready():
	if player_nbr % 2 == 0:
		self.columns = player_nbr / 2
	else:
		self.columns = (player_nbr / 2) + 1
	for i in range(1, player_nbr):
		var instance: PlayerViewport = playerViewport.instantiate()
		self.add_child(instance)
		instance.setPlayerNbr(i + 1)
		instance.setWorld(mainView.world_2d)
		players.append(instance.getPlayer())

func setPlayerToStart() -> void:
	var startPos = levelHandler.getLevelStartingPos()
	for player in players:
		player.position = startPos
		
