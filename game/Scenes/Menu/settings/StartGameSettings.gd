extends CenterContainer

@export var game_scene_path := "res://scenes/game_world/World.tscn"
@export var menu_scene := preload("res://scenes/Menu/MainMenu.tscn")
@export var action_assignement_panel_scene := preload("res://scenes/Menu/settings/actions_assignement_panel.tscn")

@export var MAX_PLAYER: int = 8

@onready var lbl: Label = $MC/VB/HB/PlayerNbr
@onready var assignement_park = $AssignementPark

const lblTxt: String = "%d Player(s)"

@export var player_count = 2:
	set(val):
		if val > 0 and val <= MAX_PLAYER:
			player_count = val
			lbl.text = lblTxt % player_count

func _ready():
	player_count = 2

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
		return false
	else:
		return true

func missing_action_loop():
	if set_missing_players_actions():
		InputHandler.save_actions_to_file()
		startGame()



func startGame() -> void:
	var game_scene = load(game_scene_path).instantiate()
	game_scene.player_count = player_count
	get_tree().root.add_child(game_scene)
	queue_free()

func _on_button_pressed():
	InputHandler.load_players_actions_from_file(player_count)
	missing_action_loop()


func _on_back_button_pressed():
	get_tree().change_scene_to_packed(menu_scene)
