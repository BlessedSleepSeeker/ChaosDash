class_name PlayerViewport
extends SubViewportContainer

@export var PLAYER_NBR: int = 2
@export var playerScene = preload("res://scenes/Character/Player.tscn")
@export var parallaxBG = preload("res://scenes/ParallaxBG.tscn")
@onready var viewport: Viewport = $SubViewport

var player: Player

func setPlayerNbr(nbr: int):
	PLAYER_NBR = nbr
	var instance: Player = playerScene.instantiate()
	instance.PLAYER_NBR = PLAYER_NBR
	player = instance
	viewport.add_child(instance)

func setWorld(world: World2D):
	viewport.world_2d = world
	var parallaxScene = parallaxBG.instantiate()
	viewport.add_child(parallaxScene)

func getPlayer() -> Player:
	return player