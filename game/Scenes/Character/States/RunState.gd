extends PlayerState

func enter(_msg := {}) -> void:
	if _msg.has("cutscene"):
		state_machine.transition_to("Cutscene")
	player.animSprite.play("run")

func handle_input(_event: InputEvent) -> void:
	player.v_direction = Input.get_axis(player.act_left, player.act_right)
	if player.v_direction == 0:
		state_machine.transition_to("Idle")
	else:
		player.consume_input()
	if Input.is_action_just_pressed(player.act_up):
		state_machine.transition_to("JumpSquat")
	if Input.is_action_just_pressed(player.act_attack):
		state_machine.transition_to("Attack")

#func get_left_right() -> float:
#	var left: float = Input.get_action_strength(player.act_left)
#	var right: float = Input.get_action_strength(player.act_right)
#	if left > 0:
#		player.consume_input()
#	if right > 0:
#		player.consume_input()
#	return right - left

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("InAir")
	player.velocity.x += (player.v_direction * player.GROUND_ACCEL)
	player.velocity.x = clampf(player.velocity.x, -player.MAX_GROUND_SPEED, player.MAX_GROUND_SPEED) + player.CHAOS_HORIZONTAL_MODIFIER / 2
	player.move_and_slide()

func exit() -> void:
	pass
