extends PlayerState

func enter(_msg := {}) -> void:
	if _msg.has("cutscene"):
		state_machine.transition_to("Cutscene")

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func jump():
	player.is_jumping = true
	player.velocity.y += player.JUMP_IMPULSE
	state_machine.transition_to("InAir")

func physics_update(_delta: float) -> void:
	player.velocity.x = clampf(player.velocity.x, -player.MAX_GROUND_SPEED, player.MAX_GROUND_SPEED)
	jump()
	player.move_and_slide()
	

func exit() -> void:
	pass
