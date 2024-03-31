class_name ChaosHandler
extends Node

@onready var worldHandler: WorldHandler = get_parent()

@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var chaosInc: Label = $M/C/ChaosIncoming
@onready var chaosDesc: Label = $M/C/ChaosDescription

@export var chaosDescStr: String = "Chaos is Rising : %s"

@export var FIRST_CHAOS_TIMER: int = 5
@export var CHAOS_COOLDOWN: int = 20

signal incoming_chaos(chaos: int)
signal unleash_chaos(chaos: int, chaosPower)

func _ready():
	chaosInc.hide()
	chaosDesc.hide()
	get_tree().create_timer(FIRST_CHAOS_TIMER).timeout.connect(_on_timer_finished)

func _on_timer_finished():
	triggerChaos(randi() % 6)
	#triggerChaos(5)
	get_tree().create_timer(CHAOS_COOLDOWN).timeout.connect(_on_timer_finished)

func triggerChaos(chaos: int) -> void:
	incoming_chaos.emit(chaos)
	chaosInc.show()
	animPlayer.play("ChaosIncomingBlink")
	await get_tree().create_timer(3).timeout
	chaosInc.hide()
	applyChaos(chaos)

func getChaosPower() -> int:
	return (randi() % 20) - 10

func applyChaos(chaos: int) -> void:
	var chaosPower = getChaosPower()
	#print(chaos)
	#print(chaosPower)
	unleash_chaos.emit(chaos, chaosPower)
	var chaosName: String
	match chaos:
		0:
			worldHandler.callPlayersFunc("chaosGravity", chaosPower)
			chaosName = "You feel %s" % ("heavier" if chaosPower <= 0 else "lighter")
		1:
			worldHandler.callPlayersFunc("chaosGROUND_FRICTION", chaosPower)
			chaosName = "Tokyo Drifting" if chaosPower <= 0 else "No Drift Allowed"
		2:
			worldHandler.callPlayersFunc("chaosWind", chaosPower / 3)
			chaosName = "The wind is blowing"
		3:
			worldHandler.callPlayersFunc("chaosGroundSpeed", chaosPower)
			chaosName = "Sprinting goes %s" % ("faster" if chaosPower >= 0 else "slower")
		4:
			worldHandler.chaosTradeOffer("position")
			chaosName = "Trade Offer : Position"
		5:
			worldHandler.chaosTradeOffer("velocity")
			chaosName = "Trade Offer : Velocity"
		_:
			chaosName = "You feel lucky..."
	chaosDesc.text = chaosDescStr % chaosName
	chaosDesc.show()
	animPlayer.play("ChaosDesc")
	await animPlayer.animation_finished
	chaosDesc.hide()
