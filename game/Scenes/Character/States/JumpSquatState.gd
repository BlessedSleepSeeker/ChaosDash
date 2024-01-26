extends PlayerState

func enter(_msg := {}) -> void:
	if _msg.has("cutscene"):
		state_machine.transition_to("Cutscene")

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_released(player.act_up):
		jump()

func update(_delta: float) -> void:
	pass

func jump():
	state_machine.transition_to("InAir")

func physics_update(_delta: float) -> void:
	player.velocity.x = clampf(player.velocity.x, -player.MAX_GROUND_SPEED, player.MAX_GROUND_SPEED)
	player.move_and_slide()
	jump()
	

func exit() -> void:
	pass
