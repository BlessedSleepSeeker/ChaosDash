class_name SplitScreenHandler
extends GridContainer

@export var playerViewport = preload("res://scenes/game_world/PlayerViewport.tscn")
@onready var mainSubviewport: PlayerViewport = $MainSubview
@onready var mainView: SubViewport = $MainSubview/SubViewport
@onready var levelHandler: LevelHandler = $MainSubview/SubViewport/LevelHandler

@export var player_nbr = 2

@onready var players: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if player_nbr % 2 == 0:
		self.columns = player_nbr / 2
	else:
		self.columns = (player_nbr / 2) + 1
	for i in range(0, player_nbr):
		var instance: PlayerViewport = null
		if i == 0:
			instance = mainSubviewport
		else:
			instance = playerViewport.instantiate()
			self.add_child(instance)
			instance.setWorld(mainView.world_2d)
		instance.setPlayerNbr(i + 1)
		players.append(instance.getPlayer())
	for p in players:
		p.pdeath.connect(_on_player_death)

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
