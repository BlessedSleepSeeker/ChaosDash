class_name Player
extends CharacterBody2D


@export var PLAYER_NBR: int = 1

#unit moved by player
@export var GRAVITY: int = 20
@export var JUMP_IMPULSE: float = -200
@export var MAX_JUMP_HOLD_FRAMES: int = 2
@export var MAX_FALL_SPEED: int = 200
@export var MAX_FASTFALL_SPEED: int = 275
@export var MAX_GROUND_SPEED: int = 125
@export var MAX_AIR_SPEED: int = 100
@export var ACCEL: int = 10
@export var FRICTION: float = 0.92
@export var AIR_DRIFT: int = 10

@onready var act_left = "p%d_left" % PLAYER_NBR
@onready var act_right = "p%d_right" % PLAYER_NBR
@onready var act_up = "p%d_up" % PLAYER_NBR
@onready var act_down = "p%d_down" % PLAYER_NBR
@onready var act_attack = "p%d_attack" % PLAYER_NBR

var is_jumping: bool = false
var is_fastfalling: bool = false
var v_direction := float()


func timer(duration, _caller):
	get_tree().create_timer(duration)

func _ready():
	pass

func _unhandled_input(_event):
	pass

func _process(_delta):
	pass


func _physics_process(_delta):
	velocity.y += GRAVITY
	if is_fastfalling:
		velocity.y = clampf(velocity.y, JUMP_IMPULSE * MAX_JUMP_HOLD_FRAMES, MAX_FASTFALL_SPEED)
	else:
		velocity.y = clampf(velocity.y, JUMP_IMPULSE * MAX_JUMP_HOLD_FRAMES, MAX_FALL_SPEED)
	#print(velocity.y)
