extends Control

@export var setting_tab_scene: PackedScene = preload("res://scenes/Menu/settings/setting_tab.tscn")

@export var back_scene: PackedScene = preload("res://scenes/Menu/MainMenu.tscn")

@onready var settings_tab: TabContainer = $MC/VB/SettingsTab
@onready var settings: Settings = get_tree().root.get_node("Root").settings

signal transition(new_scene: PackedScene)

# Called when the node enters the scene tree for the first time.
func _ready():
	for section in settings.get_sections_list():
		var instance: SettingsTab = setting_tab_scene.instantiate()
		settings_tab.add_child(instance)
		instance.settings = settings.get_settings_by_section(section)
		instance.section_name = section


func _on_quit_button_pressed():
	transition.emit(back_scene)

func _on_save_button_pressed():
	for tabs: SettingsTab in settings_tab.get_children():
		tabs.save()
	settings.apply_settings()
	settings.save_settings_to_file()
