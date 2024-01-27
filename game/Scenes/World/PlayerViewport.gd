class_name PlayerViewport
extends SubViewportContainer

@export var PLAYER_NBR: int = 2
@export var playerScene = preload("res://Scenes/Character/Player.tscn")
@onready var viewport: Viewport = $SubViewport

var player: Player

func setPlayerNbr(nbr: int):
	PLAYER_NBR = nbr
	var instance: Player = playerScene.instantiate()
	instance.PLAYER_NBR = PLAYER_NBR
	viewport.add_child(instance)

func setWorld(world: World2D):
	viewport.world_2d = world
