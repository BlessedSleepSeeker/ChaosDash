class_name PlayerViewport
extends SubViewportContainer

@export var PLAYER_NBR: int = 2
@export var playerScene = preload("res://scenes/Character/Player.tscn")
@export var parallaxBG = preload("res://scenes/ParallaxBG.tscn")
@onready var viewport: Viewport = $SubViewport

@export var energyTexture_3: CompressedTexture2D = preload("res://Assets/Player/UI/LifeCounter3.png")
@export var energyTexture_2: CompressedTexture2D = preload("res://Assets/Player/UI/LifeCounter2.png")
@export var energyTexture_1: CompressedTexture2D = preload("res://Assets/Player/UI/LifeCounter1.png")
@export var energyTexture_0: CompressedTexture2D = preload("res://Assets/Player/UI/LifeCounter0.png")

@export var portraitTexture_Neutral: CompressedTexture2D = preload("res://Assets/Player/portraitNeutral.png")
@export var portraitTexture_Dead: CompressedTexture2D = preload("res://Assets/Player/portraitDead.png")
@export var portraitTexture_Lose: CompressedTexture2D = preload("res://Assets/Player/portraitLose.png")
@export var portraitTexture_Win: CompressedTexture2D = preload("res://Assets/Player/portraitWin.png")


@onready var energyTexture: TextureRect = $M/HB/Energy
@onready var scoreLbl: Label = $M/HB/VB/Score
@onready var portraitTexture: TextureRect = $M/HB/VB/Stocks/Portrait
@onready var stockLbl: Label = $M/HB/VB/Stocks/C/Stocks
@onready var totint: MarginContainer = $M

const SCORE_STR = "%d Points"
const STOCK_STR = "x %d"

var player: Player

func setPlayerNbr(nbr: int):
	PLAYER_NBR = nbr
	var instance: Player = playerScene.instantiate()
	instance.PLAYER_NBR = PLAYER_NBR
	player = instance
	viewport.add_child(instance)
	player.stock_updated.connect(_update_stock)
	player.got_hit.connect(_update_health)
	player.score_updated.connect(_player_score_updated)
	start()

func setWorld(world: World2D):
	viewport.world_2d = world
	var parallaxScene = parallaxBG.instantiate()
	viewport.add_child(parallaxScene)

func getPlayer() -> Player:
	return player

func start():
	updateHealthUI(player.life)
	updateStockUI(player.stock)
	updateScoreUI(player.SCORE)
	updatePortrait(0)
	totint.modulate = player.getPlayerColor()

func updateHealthUI(health: int):
	match health:
		3:
			energyTexture.texture = energyTexture_3
		2:
			energyTexture.texture = energyTexture_2
		1:
			energyTexture.texture = energyTexture_1
		0:
			energyTexture.texture = energyTexture_0

func updatePortrait(status: int):
	match status:
		0:
			portraitTexture.texture = portraitTexture_Neutral
		1:
			portraitTexture.texture = portraitTexture_Dead
		2:
			portraitTexture.texture = portraitTexture_Lose
		3:
			portraitTexture.texture = portraitTexture_Win

func updateStockUI(stocks: int):
	stockLbl.text = STOCK_STR % stocks

func updateScoreUI(score: int):
	scoreLbl.text = SCORE_STR % score

func _update_stock(stocks: int):
	updateStockUI(stocks)
	if stocks > 0 and stocks != player.MAX_STOCK:
		updatePortrait(1)
		await get_tree().create_timer(1.0).timeout
		updatePortrait(0)
	elif stocks != player.MAX_STOCK:
		updatePortrait(2)

	

func _update_health(health: int):
	updateHealthUI(health)

func _player_score_updated(_p: Player, score: int):
	updateScoreUI(score)
	updatePortrait(3)
	await get_tree().create_timer(5.0).timeout
	updatePortrait(0)
