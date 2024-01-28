class_name BaseProjectile
extends Area2D


@export var SPEED: int = 400
@export var GRAVITY: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
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
	queue_free()


func _on_area_entered(_area:Area2D):
	queue_free()
