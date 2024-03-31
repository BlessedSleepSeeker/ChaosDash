extends PlayerState

var frame_count: int = 0

func enter(_msg := {}) -> void:
	if _msg.has("cutscene"):
		state_machine.transition_to("Cutscene")
	player.animSprite.play("jumpsquat")

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func jump():
	player.is_jumping = true
	if Input.is_action_pressed(player.act_up):
		player.velocity.y += player.FULLHOP_IMPULSE
	else:
		player.velocity.y += player.SHORTHOP_IMPULSE
	frame_count = 0
	state_machine.transition_to("InAir")

func physics_update(_delta: float) -> void:
	player.velocity.x = clampf(player.velocity.x, -player.MAX_GROUND_SPEED, player.MAX_GROUND_SPEED) + player.CHAOS_HORIZONTAL_MODIFIER
	frame_count += 1
	if frame_count >= player.JUMPSQUAT:
		jump()
	player.move_and_slide()
	

func exit() -> void:
	pass
