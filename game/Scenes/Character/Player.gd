class_name Player
extends CharacterBody2D

@onready var PROJO_SPAWNPOINT_R = $ProjoSpawnPointRight
@onready var PROJO_SPAWNPOINT_L = $ProjoSpawnPointLeft

@onready var state_machine = $StateMachine
@onready var hitbox = $Hitbox

@export var PLAYER_NBR: int = 1

#movement physics
@export var GRAVITY: int = 20
@export var JUMP_IMPULSE: float = -200
@export var MAX_JUMP_HOLD_FRAMES: int = 4
@export var MAX_FALL_SPEED: int = 200
@export var MAX_FASTFALL_SPEED: int = 350
@export var MAX_GROUND_SPEED: int = 125
@export var MAX_AIR_SPEED: int = 100
@export var ACCEL: int = 10
@export var FRICTION: float = 0.92
@export var AIR_DRIFT: int = 10
@export var JUMPSQUAT: int = 3

@export var ATTACK_FRAME_DATA: int = 20
@export var ATTACK_COOLDOWN: int = 80
@export var ATTACK_AIR_IASA: int = 8
@export var STUN_DURATION: int = 30
@export var GRACE_PERIOD: int = 60

signal pdeath(p: Player)
signal health_updated(life: int)
signal stock_updated(stock: int)

@export var MAX_STOCK: int = 10
var stock: int = MAX_STOCK:
	set(val):
		stock = val
		stock_updated.emit(stock)

@export var MAX_LIFE: int = 3
var life: int = MAX_LIFE:
	set(val):
		life = val
		health_updated.emit(life)

signal score_updated(p: Player, score: int)
var SCORE: int = 0:
	set(val):
		SCORE = val if val > 0 else 0
		score_updated.emit(self, SCORE)


var frame_count_grace: int = 0
var last_spawnpoint: Vector2 = Vector2.ZERO

@export var FREECAM: bool = false
@export var FREECAM_SPEED: int = 30

# chaos modifier
@export var CHAOS_HORIZONTAL_MODIFIER: int = 0

#multiplayer controls
@onready var act_left = "p%d_left" % PLAYER_NBR
@onready var act_right = "p%d_right" % PLAYER_NBR
@onready var act_up = "p%d_up" % PLAYER_NBR
@onready var act_down = "p%d_down" % PLAYER_NBR
@onready var act_attack = "p%d_attack" % PLAYER_NBR

@onready var animSprite: AnimatedSprite2D = $AnimSprite

var is_jumping: bool = false
var is_fastfalling: bool = false
var v_direction := float()

const playersColor: Array = [Color8(230, 45, 107), Color8(46, 199, 230), Color8(255, 230, 102), Color.FOREST_GREEN]



func timer(duration, _caller):
	get_tree().create_timer(duration)

func reassignControls():
	act_left = "p%d_left" % PLAYER_NBR
	act_right = "p%d_right" % PLAYER_NBR
	act_up = "p%d_up" % PLAYER_NBR
	act_down = "p%d_down" % PLAYER_NBR
	act_attack = "p%d_attack" % PLAYER_NBR

func _ready():
	animSprite.modulate = getPlayerColor()

func getPlayerColor():
	return playersColor[PLAYER_NBR - 1]

func _unhandled_input(_event):
	pass

func _process(_delta):
	if v_direction < 0:
		animSprite.flip_h = true
	elif v_direction > 0:
		animSprite.flip_h = false

func _physics_process(_delta):
	frame_count_grace += 1
	if not FREECAM:
		velocity.y += GRAVITY
	if is_fastfalling:
		velocity.y = clampf(velocity.y, JUMP_IMPULSE * MAX_JUMP_HOLD_FRAMES, MAX_FASTFALL_SPEED)
	else:
		velocity.y = clampf(velocity.y, JUMP_IMPULSE * MAX_JUMP_HOLD_FRAMES, MAX_FALL_SPEED)
	#print(velocity.y)

func chaosGravity(newGrav: int):
	GRAVITY -= newGrav

func chaosFriction(newFric: float):
	FRICTION -= newFric / 100
	if FRICTION > 1:
		FRICTION = 1

func chaosChargedJump(new: int):
	MAX_JUMP_HOLD_FRAMES += new

func chaosWind(wind: int):
	CHAOS_HORIZONTAL_MODIFIER += wind

func chaosGroundSpeed(new: int):
	MAX_GROUND_SPEED += new

signal got_hit(remainingLife: int)

func hit() -> void:
	if frame_count_grace > GRACE_PERIOD:
		frame_count_grace = 0
		life -= 1
		got_hit.emit(life)
		if life > 0:
			state_machine.transition_to("FreeFall")
		else:
			life = MAX_LIFE
			death()

signal died(remainingStocks: int)

func death() -> int:
	stock -= 1
	SCORE -= 1
	state_machine.transition_to("Death")
	await get_tree().create_timer(1.0).timeout
	resurect(last_spawnpoint)
	pdeath.emit(self)
	died.emit(stock)
	return stock

func parade() -> void:
	state_machine.transition_to("Parade")

signal getting_ready

func readyLevel(startPos: Vector2) -> void:
	last_spawnpoint = startPos
	life = MAX_LIFE
	position = startPos
	velocity.x = 0
	velocity.y = 0
	getting_ready.emit()
	state_machine.transition_to("Idle")

func resurect(startPos: Vector2) -> void:
	if stock > 0:
		readyLevel(startPos)
	else:
		eliminated()

signal _eliminated

func eliminated() -> void:
	state_machine.transition_to("OutOfGame")
	_eliminated.emit()