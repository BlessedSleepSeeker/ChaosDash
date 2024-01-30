class_name PlayerViewport
extends SubViewportContainer

@export var PLAYER_NBR: int = 2
@export var player_scene = preload("res://scenes/Character/Player.tscn")
@export var parallax_BG = preload("res://scenes/parallaxBG.tscn")
@onready var viewport: Viewport = $SubViewport

@export var energy_texture_3: CompressedTexture2D = preload("res://Assets/Player/UI/LifeCounter3.png")
@export var energy_texture_2: CompressedTexture2D = preload("res://Assets/Player/UI/LifeCounter2.png")
@export var energy_texture_1: CompressedTexture2D = preload("res://Assets/Player/UI/LifeCounter1.png")
@export var energy_texture_0: CompressedTexture2D = preload("res://Assets/Player/UI/LifeCounter0.png")

@export var portrait_texture_neutral: CompressedTexture2D = preload("res://Assets/Player/portraitNeutral.png")
@export var portrait_texture_dead: CompressedTexture2D = preload("res://Assets/Player/portraitDead.png")
@export var portrait_texture_lose: CompressedTexture2D = preload("res://Assets/Player/portraitLose.png")
@export var portrait_texture_win: CompressedTexture2D = preload("res://Assets/Player/portraitWin.png")


@onready var energy_texture: TextureRect = $M/HB/Energy
@onready var score_lbl: Label = $M/HB/VB/Score
@onready var portrait_texture: TextureRect = $M/HB/VB/Stocks/Portrait
@onready var stock_lbl: Label = $M/HB/VB/Stocks/C/Stocks
@onready var totint: MarginContainer = $M

const SCORE_STR = "%d Points"
const STOCK_STR = "x %d"

var player: Player

# we need only one viewport to host the actual level, every other viewport get a pointer to this one's world_2d
func set_level_handler(levelHandler: LevelHandler) -> World2D:
	viewport.add_child(levelHandler)
	return viewport.world_2d

func set_player_nbr(nbr: int):
	PLAYER_NBR = nbr
	var instance: Player = player_scene.instantiate()
	instance.PLAYER_NBR = PLAYER_NBR
	player = instance
	viewport.add_child(instance)
	player.stock_updated.connect(_update_stock)
	player.got_hit.connect(_update_health)
	player.respawning.connect(_update_health)
	player.score_updated.connect(_player_score_updated)
	start()

func set_world(world: World2D):
	viewport.world_2d = world
	var parallaxScene = parallax_BG.instantiate()
	viewport.add_child(parallaxScene)

func get_player() -> Player:
	return player

func start():
	update_health_ui(player.life)
	update_stock_ui(player.stock)
	updateScoreUI(player.SCORE)
	update_portrait(0)
	totint.modulate = player.getPlayerColor()

func update_health_ui(health: int):
	match health:
		3:
			energy_texture.texture = energy_texture_3
		2:
			energy_texture.texture = energy_texture_2
		1:
			energy_texture.texture = energy_texture_1
		0:
			energy_texture.texture = energy_texture_0

func update_portrait(status: int):
	match status:
		0:
			portrait_texture.texture = portrait_texture_neutral
		1:
			portrait_texture.texture = portrait_texture_dead
		2:
			portrait_texture.texture = portrait_texture_lose
		3:
			portrait_texture.texture = portrait_texture_win


func update_stock_ui(stocks: int):
	stock_lbl.text = STOCK_STR % stocks

func updateScoreUI(score: int):
	score_lbl.text = SCORE_STR % score

func _update_stock(stocks: int):
	update_stock_ui(stocks)
	if stocks > 0 and stocks != player.MAX_STOCK:
		update_portrait(1)
		await get_tree().create_timer(1.0).timeout
		update_portrait(0)
	elif stocks != player.MAX_STOCK:
		update_portrait(2)


func _update_health(health: int):
	update_health_ui(health)


func _player_score_updated(_p: Player, new_score: int, old_score: int):
	updateScoreUI(new_score)
	if old_score < new_score:
		update_portrait(3)
		await get_tree().create_timer(5.0).timeout
		update_portrait(0)
