extends PlayerState

var frame_count: int = 0

@onready var sound_player: AudioStreamPlayer = $AudioPlayer
var air_dash_dir: int = 1

func enter(_msg := {}) -> void:
	player.AFFECTED_BY_GRAVITY = false
	frame_count = 0
	player.velocity.y = 0
	if player.animSprite.flip_h:
		air_dash_dir = -1
	else:
		air_dash_dir = 1
	#player.animSprite.play("AirDash")
	sound_player.play()

func handle_input(_event: InputEvent) -> void:
	#player.v_direction = Input.get_axis(player.act_left, player.act_right)
	pass
	

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	player.velocity.x = player.AIR_DASH_SPEED * air_dash_dir
	player.move_and_slide()
	if frame_count >= player.AIR_DASH_DURATION:
		state_machine.transition_to("InAir")
	frame_count += 1


func exit() -> void:
	player.AFFECTED_BY_GRAVITY = true
	frame_count = 0
