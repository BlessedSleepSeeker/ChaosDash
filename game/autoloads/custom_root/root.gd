class_name Root
extends Node

@export var main_menu = preload("res://scenes/Menu/MainMenu.tscn")
@onready var settings = $Settings
@onready var scene_root = $SceneRoot
@onready var animator: AnimationPlayer = $Animator

# Called when the node enters the scene tree for the first time.
func _ready():
	add_scene(main_menu)

func flush_scenes():
	for child in scene_root.get_children():
		child.queue_free()

func add_scene(new_scene: PackedScene):
	var instance = new_scene.instantiate()
	if instance.has_signal("transition"):
		instance.transition.connect(_on_transition)
	scene_root.add_child(instance)

func change_scene(new_scene: PackedScene):
	flush_scenes()
	add_scene(new_scene)

func _on_transition(new_scene: PackedScene):
	animator.play("scene_transition_in")
	await animator.animation_finished
	animator.play("scene_transition_out")
	change_scene(new_scene)