extends PlayerState

func enter(_msg := {}) -> void:
	player.animSprite.play("freefall")
	player.animSprite.rotation_degrees = -90

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		state_machine.transition_to("Stun")
	player.velocity.x = player.CHAOS_HORIZONTAL_MODIFIER
	player.move_and_slide()

func exit() -> void:
	player.animSprite.rotation_degrees = 0