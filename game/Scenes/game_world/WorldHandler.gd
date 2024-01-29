class_name WorldHandler
extends Node

@export var playerViewportScene = preload("res://scenes/game_world/PlayerViewport.tscn")
@export var levelHandlerScene = preload("res://scenes/game_world/LevelHandler.tscn")

@onready var splitGrid: GridContainer = $SplitGrid
@onready var chaosHandler: ChaosHandler = $ChaosHandler

@export var difficulty: int = 0
@export var player_count: int = 0

@onready var players: Array = []
var levelHandler: LevelHandler

var levelTransition: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():

	# Add a columns for player 3, 5, 7 and so on..
	splitGrid.columns = (player_count / 2) + player_count % 2

	var levelHandlerWorld: World2D = null
	for i in range(0, player_count):
		var playerViewport: PlayerViewport = null
		playerViewport = playerViewportScene.instantiate()
		splitGrid.add_child(playerViewport)
		if i == 0:
			levelHandler = levelHandlerScene.instantiate()
			# we need only one viewport to host the actual level, every other viewport get a pointer to this one's world_2d
			levelHandlerWorld = playerViewport.setLevelHandler(levelHandler)
		else:
			playerViewport.setWorld(levelHandlerWorld)
		playerViewport.setPlayerNbr(i + 1)
		players.append(playerViewport.getPlayer())
	connectToLvlHandler()
	createPlayersActions()
	setUpLevel(difficulty)

func createPlayersActions() -> void:
	pass

func connectToLvlHandler() -> void:
	levelHandler.level_finished.connect(_on_level_finished)
	levelHandler.level_started.connect(_on_level_started)
	levelHandler.player_death.connect(_on_player_death)

func setUpLevel(_lvlDifficulty: int) -> void:
	levelHandler.loadLevel(self.difficulty)
	setPlayerToStart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if levelTransition:
		levelTransition = !levelTransition
		levelHandler.unloadLevel()
		setUpLevel(difficulty)

func _on_level_finished(_body: Node2D):
	if _body is Player:
		_body.SCORE += 30
		_body.state_machine.transition_to("parade")
	resetPlayersForNewLevel()
	levelTransition = true
	if self.difficulty == 0:
		self.difficulty += 1

func _on_level_started():
	pass


func setup():
	pass

func setPlayerToStart() -> void:
	var startPos = levelHandler.getSpawnPoints()
	var i: int = 0
	for player in players:
		player.position = startPos[i]
		player.last_spawnpoint = startPos[i]
		i += 1
		if i >= startPos.size():
			i = 0

func chaosTradeOffer(param: String):
	var params: Array = []
	for p in players:
		if p.state_machine.state.name != "Death" || p.state_machine.state.name != "OutOfGame":
			params.append(p.get(param))
	var i := 1
	#print_debug(params)
	for p in players:
		if p.state_machine.state.name != "Death" || p.state_machine.state.name != "OutOfGame":
			p.set(param, params[i])
			i += 1
			if i >= params.size():
				i = 0

func callPlayersFunc(funcName: String, params: Variant = null):
	for player in players:
		var funk = Callable(player, funcName)
		funk.call(params)

func checkElimination() -> void:
	var i := 0
	var winner = null
	for p in players:
		if p.state_machine.state.name == "OutOfGame":
			i += 1
		else:
			winner = p
	if i == players.size() - 1:
		setAsWinner(winner)

func setAsWinner(p: Player):
	levelHandler._on_goal_reached(p)

func _on_player_death(_body: Player):
	if _body.state_machine.state.name == "OutOfGame":
		checkElimination()

func resetPlayersForNewLevel():
	for p in players:
		p.life = p.MAX_LIFE
		p.stock = p.MAX_STOCK
		p.state_machine.transition_to("Idle")
