extends PlayerState

var frame_count: int = 0

func enter(_msg := {}) -> void:
	player.animSprite.play("groundstun")

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if frame_count > player.STUN_DURATION:
		state_machine.transition_to("Idle")
	player.velocity.x = player.CHAOS_HORIZONTAL_MODIFIER
	player.move_and_slide()
	frame_count += 1

func exit() -> void:
	frame_count = 0