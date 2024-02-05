extends AnimatedSprite2D

@export var player_nbr = 0:
	set(val):
		player_nbr = val
		modulate_color()

@export var state: String = "NotPresent"
@export var possible_states: Array = ["NotPresent", "Spawning", "Idling", "Dying"]

const players_color: Array = [Color8(230, 45, 107), Color8(46, 199, 230), Color8(255, 230, 102), Color.FOREST_GREEN, Color.CRIMSON, Color.DARK_TURQUOISE, Color.GOLD, Color.SEA_GREEN]

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	animate()

func modulate_color() -> void:
	modulate = players_color[player_nbr - 1]

func animate() -> void:
	match state:
		"NotPresent":
			pass
		"Dying":
			play("death")
			await animation_finished
			state = "NotPresent"
			hide()
		"Spawning":
			show()
			play_backwards("death")
			await animation_finished
			state = "Idling"
			play("idle")
		"Idle":
			pass
