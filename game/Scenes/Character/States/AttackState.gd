extends PlayerState


@export var projectile: PackedScene = preload("res://scenes/Character/Attack/BaseProj.tscn")
var frame_count: int = 0

@onready var sound_player: RandomStreamPlayer = $AudioPlayer

func enter(_msg := {}) -> void:
	frame_count = 0
	if _msg.has("cutscene"):
		state_machine.transition_to("Cutscene")
	player.animSprite.play("attack")
	sound_player.play_random()
	var instance = projectile.instantiate()
	player.get_parent().add_child(instance)
	#instance.setGravity(player.GRAVITY)
	instance.setSpeed(player.animSprite.flip_h)
	if player.animSprite.flip_h:
		instance.transform = player.PROJO_SPAWNPOINT_L.global_transform
	else:
		instance.transform = player.PROJO_SPAWNPOINT_R.global_transform


func handle_input(_event: InputEvent) -> void:
	player.v_direction = Input.get_axis(player.act_left, player.act_right)

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if not player.is_on_floor() and frame_count > player.ATTACK_AIR_IASA:
		state_machine.transition_to("InAir")
	player.velocity.x = clampf(player.velocity.x, -player.MAX_GROUND_SPEED, player.MAX_GROUND_SPEED)
	player.move_and_slide()
	if frame_count > player.ATTACK_FRAME_DATA:
		if player.v_direction == 0:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	frame_count += 1

func exit() -> void:
	frame_count = 0
