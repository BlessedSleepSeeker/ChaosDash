extends Control

@export var game_scene := preload("res://scenes/game_world/World.tscn")
@export var menu_scene := preload("res://scenes/Menu/MainMenu.tscn")
@export var action_assignement_panel_scene := preload("res://scenes/Menu/settings/actions_assignement_panel.tscn")

@export var MAX_PLAYER: int = 8

@onready var lbl: Label = $MC/C/VB/C3/PlayerNbr
@onready var assignement_park = $MC/C/AssignementPark
@onready var pdisplay = $PlayerDisplay
@onready var up_button: TextureButton = $MC/C/VB/C1/UpButton
@onready var down_button: TextureButton = $MC/C/VB/C2/DownButton

signal transition(new_scene: PackedScene, animation: String)

const lblTxt: String = "%d Player(s)"

@export var player_count = 1:
	set(val):
		if val > 0 and val <= MAX_PLAYER:
			player_count = val
			lbl.text = lblTxt % player_count
			play_player_anim()

func _ready():
	player_count = 1

func play_player_anim():
	var i := 1
	for p: AnimatedSprite2D in pdisplay.get_children():
		if i <= player_count:
			if p.state == 'NotPresent' or p.state == "Dying":
				p.state = 'Spawning'
		else:
			if p.state == "Idling" or p.state == "Spawning":
				p.state = "Dying"
		p.animate()
		i += 1

func _on_up_button_pressed():
	player_count += 1

func _on_down_button_pressed():
	player_count -= 1

func set_missing_players_actions() -> bool:
	var missing_action = InputHandler.check_players_actions(player_count)
	if missing_action != "":
		var instance = action_assignement_panel_scene.instantiate()
		instance.action_set.connect(missing_action_loop)
		add_child(instance)
		instance.action_name = missing_action
		#instance.global_position = assignement_park.global_position
		return false
	else:
		return true

func missing_action_loop():
	if set_missing_players_actions():
		InputHandler.save_actions_to_file()
		startGame()


func startGame() -> void:
	# can't pass data between scene otherwise due to the new transition system.
	GlobalVars.PLAYER_COUNT = player_count
	transition.emit(game_scene, "scene_transition")


func _on_button_pressed():
	InputHandler.load_players_actions_from_file(player_count)
	missing_action_loop()


func _on_back_button_pressed():
	transition.emit(menu_scene, "scene_transition")


func _on_up_button_mouse_exited():
	up_button.release_focus()


func _on_down_button_mouse_exited():
	down_button.release_focus()
