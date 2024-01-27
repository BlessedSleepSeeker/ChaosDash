extends PlayerState

var frame_count: int = 0
var boost_jump: bool = true

func enter(_msg := {}) -> void:
	boost_jump = true
	player.is_fastfalling = false
	frame_count = 0
	if _msg.has("cutscene"):
		state_machine.transition_to("Cutscene")
	if player.is_jumping:
		player.animSprite.play("jump")

func handle_input(_event: InputEvent) -> void:
	player.v_direction = Input.get_axis(player.act_left, player.act_right)
	if Input.is_action_just_released(player.act_up):
		boost_jump = false
	if Input.is_action_just_pressed(player.act_down) and player.velocity.y > 0:
		player.is_fastfalling = true
		player.animSprite.play("fall")

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	#print(boost_jump)
	#print(player.is_jumping)
	#print(frame_count)
	if boost_jump and player.is_jumping and frame_count < player.MAX_JUMP_HOLD_FRAMES and frame_count % 2 == 1:
		player.velocity.y += player.JUMP_IMPULSE / frame_count
	player.velocity.x += player.v_direction * player.AIR_DRIFT
	player.velocity.x = clampf(player.velocity.x, -player.MAX_AIR_SPEED, player.MAX_AIR_SPEED)
	player.move_and_slide()
	if player.is_on_floor():
		if player.v_direction != 0:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
	frame_count += 1

func exit() -> void:
	frame_count = 0
	player.is_jumping = false
	player.is_fastfalling = false
