extends Setting

@export var main_menu = preload("res://scenes/Menu/MainMenu.tscn")
@onready var sprite: AnimatedSprite2D = $LogoAnimation

signal transition(new_scene: PackedScene, with_animation: bool)

func _ready():
	sprite.play("logo")
	await sprite.animation_finished
	await get_tree().create_timer(0.5).timeout
	transition.emit(main_menu, false)

func _unhandled_input(event):
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadMotion or event is InputEventJoypadButton:
		transition.emit(main_menu, false)
