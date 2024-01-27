class_name SplitScreenHandler
extends GridContainer

@export var playerViewport = preload("res://Scenes/World/PlayerViewport.tscn")
@onready var mainSubviewport = $MainSubview
@onready var mainView = $MainSubview/SubViewport


@export var player_nbr = 2

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
		
