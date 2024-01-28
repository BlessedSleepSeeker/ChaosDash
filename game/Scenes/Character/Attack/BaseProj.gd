class_name BaseProjectile
extends Area2D


@export var SPEED: int = 400
@export var GRAVITY: int = 0
@export var LIFETIME: int = 600

var frame_count_lifetime: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if frame_count_lifetime > LIFETIME:
		triggerDeath()
	frame_count_lifetime += 1
	position += transform.x * SPEED * delta
	position += transform.y * GRAVITY * delta

func setGravity(grav: int) -> void:
	GRAVITY = grav

func setSpeed(flipped: bool) -> void:
	if flipped:
		SPEED = SPEED * -1
	else:
		SPEED = SPEED

func _on_body_entered(body:Node2D):
	if body.has_method("hit"):
		body.hit()
	triggerDeath()

func _on_area_entered(_area:Area2D):
	triggerDeath()

func triggerDeath():
	queue_free()