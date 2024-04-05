class_name Player
extends CharacterBody2D

@onready var PROJO_SPAWNPOINT_R = $ProjoSpawnPointRight
@onready var PROJO_SPAWNPOINT_L = $ProjoSpawnPointLeft

@onready var state_machine: StateMachine = $StateMachine
@onready var hitbox = $Hitbox
@onready var animSprite: AnimatedSprite2D = $AnimSprite

@export var PLAYER_NBR: int = 1 ## Variable to handle control and color.

@export_group("Physics Variables")
@export var GRAVITY: int = 20
@export var AFFECTED_BY_GRAVITY: bool = true
@export var JUMPSQUAT: int = 5
@export var SHORTHOP_IMPULSE: float = -250 ## Added to vertical velocity if the jump button is released before the end of jumpsquat.
@export var FULLHOP_IMPULSE: float = -400 ## Added to vertical velocity if the jump button is still held at the end of jumpsquat.
@export var MAX_FALL_SPEED: int = 200
@export var MAX_FASTFALL_SPEED: int = 350

@export var GROUND_ACCEL: int = 10
@export_range(0, 1, 0.01) var GROUND_FRICTION: float = 0.8 ## If on ground, is multiplied to the current velocity every frame. 0 : instant stop, 1 : never stop.
@export var MAX_GROUND_SPEED: int = 125

@export var AIR_ACCEL: int = 4
@export_range(0, 1, 0.01) var AIR_DRIFT: float = 0.98 ## If on air, multiplied to the current velocity every frame. 0 : instant stop, 1 : never stop.
@export var MAX_AIR_SPEED: int = 100

@export var AIR_DASH_SPEED: int = 200
@export var AIR_DASH_DURATION: int = 20 ## In Physics Frames
@export var MAX_AIR_DASH: int = 1 ## Airdashes refresh once the player has touched the ground.
var airdash_done: int = 0

@export_group("Combat Variables")
@export var ATTACK_FRAME_DATA: int = 20 ## In Physics Frames
@export var ATTACK_COOLDOWN: int = 80 ## In Physics Frames
@export var ATTACK_AIR_IASA: int = 8 ## Interuptible As Soon As
@export var STUN_DURATION: int = 30 ## Stun Duration once grounded. In Physics Frames.
@export var GRACE_PERIOD: int = 60 ## Invulnerability after getting hit to avoid stunlocking. In Physics Frames.

var frame_count_grace: int = 0
var last_spawnpoint: Vector2 = Vector2.ZERO

signal respawning(life: int)
signal stock_updated(stock: int)
@export var MAX_STOCK: int = 10
var stock: int = MAX_STOCK:
	set(val):
		stock = val
		stock_updated.emit(stock)

signal health_updated(life: int)
@export var MAX_LIFE: int = 3
var life: int = MAX_LIFE:
	set(val):
		life = val
		health_updated.emit(life)

signal score_updated(p: Player, new_score: int, old_score: int)
var SCORE: int = 0:
	set(val):
		val = val if val > 0 else 0
		score_updated.emit(self, val, SCORE)
		SCORE = val

@export_group("FreeCam State Variables")
@export var FREECAM_SPEED: int = 30

@export_group("Chaos Modifiers")
@export var CHAOS_HORIZONTAL_MODIFIER: float = 0.0

#multiplayer controls
@onready var act_left = "p%d_left" % PLAYER_NBR
@onready var act_right = "p%d_right" % PLAYER_NBR
@onready var act_up = "p%d_up" % PLAYER_NBR
@onready var act_down = "p%d_down" % PLAYER_NBR
@onready var act_attack = "p%d_attack" % PLAYER_NBR

var is_jumping: bool = false
var is_fastfalling: bool = false
var v_direction := float()

const playersColor: Array = [Color8(230, 45, 107), Color8(46, 199, 230), Color8(255, 230, 102), Color.FOREST_GREEN, Color.CRIMSON, Color.DARK_TURQUOISE, Color.GOLD, Color.SEA_GREEN]



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
	return playersColor[PLAYER_NBR - 1] if PLAYER_NBR - 1 < playersColor.size() else Color.SIENNA

#region Buffering Implementation

# @export_group("Input Buffering")
# @export_range(0, 100, 1) var BUFFER_SIZE: int = 0 # Physics Frames of input buffering.
# var INPUT_BUFFER: Array[String]
# var INPUT_TIMMING: Array[int]

# func _unhandled_input(_event: InputEvent):
# 	if Input.is_action_pressed(act_left):
# 		add_to_buffer(act_left)
# 	if Input.is_action_pressed(act_right):
# 		add_to_buffer(act_right)
# 	if Input.is_action_pressed(act_up):
# 		add_to_buffer(act_up)
# 	if Input.is_action_pressed(act_down):
# 		add_to_buffer(act_down)
# 	if Input.is_action_pressed(act_attack):
# 		add_to_buffer(act_attack)
# 	print_buffer()
# 	send_buffered_input()
# 	process_buffer()

# func add_to_buffer(action: String) -> void:
# 	INPUT_BUFFER.append(action)
# 	INPUT_TIMMING.append(BUFFER_SIZE)

# ## Press the action and call the state machine input handling.
# func send_buffered_input() -> void:
# 	if INPUT_BUFFER.size() > 0:
# 		Input.action_press(INPUT_BUFFER.front())
# 		state_machine._unhandled_input(null)

# ## Called by states when they consume an input.
# func consume_input() -> void:
# 	INPUT_BUFFER.pop_front()
# 	INPUT_TIMMING.pop_front()

# ## Remove and Age buffered actions.
# func process_buffer():
# 	if INPUT_BUFFER.size() > 0:
# 		if INPUT_TIMMING[0] == 0:
# 			consume_input()
# 			process_buffer()
# 		if INPUT_TIMMING[0] > 0:
# 			INPUT_TIMMING[0] -= 1		

# func print_buffer():
# 	for i in range(INPUT_BUFFER.size()):
# 		print("%s : %d" % [INPUT_BUFFER[i], INPUT_TIMMING[i]])

#endregion

func _process(_delta):
	if v_direction < 0:
		animSprite.flip_h = true
	elif v_direction > 0:
		animSprite.flip_h = false

func _physics_process(_delta):
	frame_count_grace += 1
	if AFFECTED_BY_GRAVITY:
		velocity.y += GRAVITY
	velocity.y = clampf(velocity.y, FULLHOP_IMPULSE, MAX_FASTFALL_SPEED if is_fastfalling else MAX_FALL_SPEED)
	#print(velocity.y)

#region Chaos Handling

func chaosGravity(newGrav: int):
	GRAVITY -= newGrav

func chaosGROUND_FRICTION(newFric: float):
	GROUND_FRICTION -= newFric / 100
	if GROUND_FRICTION > 1:
		GROUND_FRICTION = 1

func chaosChargedJump(new: int):
	pass

func chaosWind(wind: int):
	CHAOS_HORIZONTAL_MODIFIER += wind

func chaosGroundSpeed(new: int):
	MAX_GROUND_SPEED += new

#endregion

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
	died.emit(stock)
	return stock

# Celebration, not parry
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
		respawning.emit(life)
	else:
		eliminated()

signal _eliminated

func eliminated() -> void:
	state_machine.transition_to("OutOfGame")
	_eliminated.emit()

# # Helper function to streamline basic grounded movement physics
# func calcHVelocityGrounded(current_velocity: float, input_dir: float = 0.0) -> float:
# 	current_velocity += (input_dir * GROUND_FRICTION)
# 	return clampf(current_velocity, -MAX_GROUND_SPEED, MAX_GROUND_SPEED) + CHAOS_HORIZONTAL_MODIFIER

# # Helper function to streamline basic aerial movement physics
# func calcHVelocityAir(x_velocity) -> float:
# 	return clampf((x_velocity * AIR_DRIFT), -MAX_AIR_SPEED, MAX_AIR_SPEED) + CHAOS_HORIZONTAL_MODIFIER