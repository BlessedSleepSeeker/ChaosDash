extends PlayerState

var frame_count: int = 0
var boost_jump: bool = false

func enter(_msg := {}) -> void:
	frame_count = 0
	if _msg.has("cutscene"):
		state_machine.transition_to("Cutscene")

func handle_input(_event: InputEvent) -> void:
	boost_jump = false
	player.v_direction = Input.get_axis(player.act_left, player.act_right)
	if frame_count < player.MAX_JUMP_HOLD_FRAMES and Input.is_action_pressed(player.act_up):
		boost_jump = true
	frame_count += 1

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if boost_jump:
		player.velocity.y += player.JUMP_IMPULSE / frame_count
	player.velocity.x += player.v_direction * player.AIR_DRIFT
	player.velocity.x = clampf(player.velocity.x, -player.MAX_AIR_SPEED, player.MAX_AIR_SPEED)
	player.move_and_slide()
	if player.is_on_floor():
		if player.v_direction != 0:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")

func exit() -> void:
	frame_count = 0
