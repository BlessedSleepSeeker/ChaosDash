extends PlayerState

var frame_count: int = 0

func enter(_msg := {}) -> void:
	player.is_fastfalling = false
	frame_count = 0
	if _msg.has("cutscene"):
		state_machine.transition_to("Cutscene")
	if player.is_jumping:
		player.animSprite.play("jump")

func handle_input(_event: InputEvent) -> void:
	player.v_direction = Input.get_axis(player.act_left, player.act_right)
	if Input.is_action_just_pressed(player.act_down) and player.velocity.y > 0:
		player.is_fastfalling = true
	if Input.is_action_just_pressed(player.act_attack):
		state_machine.transition_to("Attack")
	if Input.is_action_just_pressed(player.act_up) and player.airdash_done < player.MAX_AIR_DASH:
		player.airdash_done += 1
		state_machine.transition_to("AirDash")

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	# First, apply player input, multiplied by the air accel.
	player.velocity.x += (player.v_direction * player.AIR_ACCEL)
	# Then, we apply the drift, or air friction : try to go back to 0
	player.velocity.x *= player.AIR_DRIFT
	# Clamp it to min/max speed and add the chaos mod.
	player.velocity.x = clampf(player.velocity.x, -player.MAX_AIR_SPEED, player.MAX_AIR_SPEED) + player.CHAOS_HORIZONTAL_MODIFIER
	if player.velocity.y > 0:
		player.animSprite.play("fall")
	player.move_and_slide()
	if player.is_on_floor():
		player.airdash_done = 0
		if player.v_direction != 0:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
	frame_count += 1

func exit() -> void:
	frame_count = 0
	player.is_jumping = false
	player.is_fastfalling = false
