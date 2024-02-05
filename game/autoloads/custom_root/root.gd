class_name Root
extends Node

@export var first_scene: PackedScene = preload("res://scenes/TitleSequence/TitleSequence.tscn")
@onready var settings = $Settings
@onready var scene_root = $SceneRoot
@onready var animator: AnimationPlayer = $Animator

# Called when the node enters the scene tree for the first time.
func _ready():
	add_scene(first_scene)

func flush_scenes():
	for child in scene_root.get_children():
		child.queue_free()

func add_scene(new_scene: PackedScene):
	var instance = new_scene.instantiate()
	print_debug(instance.has_signal("transition"))
	if instance.has_signal("transition") and not instance.transition.is_connected(_on_transition):
		instance.transition.connect(_on_transition)
	scene_root.add_child(instance)

func change_scene(new_scene: PackedScene):
	flush_scenes()
	add_scene(new_scene)

func _on_transition(new_scene: PackedScene, with_animation: bool):
	print_debug(with_animation)
	if with_animation:
		animator.play("scene_transition_in")
		await animator.animation_finished
		change_scene(new_scene)
		animator.play("scene_transition_out")
	else:
		change_scene(new_scene)
	