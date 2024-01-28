class_name ChaosHandler
extends Node

@onready var levelHandler: LevelHandler = get_parent().get_node("SplitScreenHandler").get_node("MainSubview").get_node("SubViewport").get_node("LevelHandler")
@onready var splitscreenHandler: SplitScreenHandler = get_parent().get_node("SplitScreenHandler")

@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var chaosInc: Label = $M/C/ChaosIncoming
@onready var chaosDesc: Label = $M/C/ChaosDescription

@export var chaosDescStr: String = "Chaos is Rising : %s"

@export var FIRST_CHAOS_TIMER: int = 10
@export var CHAOS_COOLDOWN: int = 20

signal incoming_chaos(chaos: int)
signal unleash_chaos(chaos: int, chaosPower)

func _ready():
	chaosInc.hide()
	chaosDesc.hide()
	get_tree().create_timer(FIRST_CHAOS_TIMER).timeout.connect(_on_timer_finished)

func _on_timer_finished():
	triggerChaos(randi() % 3)
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
	print(chaos)
	print(chaosPower)
	unleash_chaos.emit(chaos, chaosPower)
	var chaosName: String
	match chaos:
		0:
			splitscreenHandler.callPlayersFunc("chaosGravity", chaosPower)
			chaosName = "You feel %s" % ("heavier" if chaosPower <= 0 else "lighter")
		1:
			splitscreenHandler.callPlayersFunc("chaosFriction", chaosPower)
			chaosName = "Tokyo Drifting" if chaosPower <= 0 else "No Drift Allowed"
		2:
			splitscreenHandler.callPlayersFunc("chaosWind", chaosPower / 3)
			chaosName = "The wind is blowing"
		3:
			splitscreenHandler.callPlayersFunc("chaosGroundSpeed", chaosPower)
			chaosName = "Sprinting goes %s" % "faster" if chaosPower >= 0 else "slower"
		_:
			chaosName = "You feel lucky..."
	chaosDesc.text = chaosDescStr % chaosName
	chaosDesc.show()
	animPlayer.play("ChaosDesc")
	await animPlayer.animation_finished
	chaosDesc.hide()
