extends PlayerState

var freecam_dir = Vector2.ZERO

func enter(_msg := {}) -> void:
	player.FREECAM = true
	player.hitbox.set_deferred("disabled", true)
	player.animSprite.play("outofgame")
	player.velocity = Vector2.ZERO

func handle_input(_event: InputEvent) -> void:
	freecam_dir = Input.get_vector(player.act_left, player.act_right, player.act_up, player.act_down)

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	player.velocity.x = (player.velocity.x + freecam_dir.x * player.FREECAM_SPEED) * player.FRICTION
	player.velocity.y = (player.velocity.y + freecam_dir.y * player.FREECAM_SPEED) * player.FRICTION
	player.move_and_slide()

func exit() -> void:
	player.FREECAM = false
	player.hitbox.set_deferred("disabled", false)
