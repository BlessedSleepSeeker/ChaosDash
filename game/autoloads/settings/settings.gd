extends Node

@export var user_settings_file_path: String = "user://settings/game_settings.cfg"

#setting file path
@onready var settings_file := ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if load_setting_file() == OK:
		pass#load_settings_from_file()
	apply_settings()
	save_settings_to_file()

## Settings Getters

func get_sections_list() -> Array:
	var sections: Array = []
	for sett in get_children():
		if !sections.has(sett.section):
			sections.append(sett.section)
	return sections

func get_settings_by_section(section: String) -> Array:
	var settings_by_section: Array = []
	for sett in get_children():
		if sett.section == section:
			settings_by_section.append(sett)
	return settings_by_section

## File interaction

func change_settings_file_path(new_path: String) -> void:
	user_settings_file_path = new_path

func load_setting_file() -> int:
	var err = settings_file.load(user_settings_file_path)
	if err != OK:
		printerr("Something happened at %s, error code [%d]" % [user_settings_file_path, err])
	return err


func load_settings_from_file() -> void:
	for setting in get_children():
		if settings_file.has_section(setting.section) and settings_file.has_section_key(setting.section, setting.key):
			setting.value = get_file_value(setting.section, setting.key)

# save_settings_to_file() will get the values inside the settings array and put them in the file.
# we need to call save_to_file() only when the settings are modified
func save_settings_to_file() -> int:
	print_debug('Saving file at %s' % user_settings_file_path)

	for setting in get_children():
		set_file_value(setting.section, setting.key, setting.value)

	var err = settings_file.save(user_settings_file_path)
	if err != OK:
		printerr("Error code [%d]. Something went wrong saving the file at %s." % [err, user_settings_file_path])
	return err

func get_file_value(section: String, setting: String) -> Variant:
	return settings_file.get_value(section, setting, "")

func set_file_value(section: String, setting: String, value: Variant) -> void:
	settings_file.set_value(section, setting, value)

## Settings Interaction

func print_settings() -> void:
	for seti in get_children():
		print_debug(seti.get_print_string())

func create_bool_setting(section: String, key: String, value: Variant): #automaticaly set the default value to the value you give him at creation
	add_setting(Setting.new(section, key, value, value, Setting.SETTING_TYPE.BOOLEAN))

func create_range_setting(section: String, key: String, value: Variant, min_value: int, max_value: int):
	add_setting(Setting.new(section, key, value, value, Setting.SETTING_TYPE.RANGE, min_value, max_value))

func create_option_setting(section: String, key: String, value: Variant, options: Array):
	add_setting(Setting.new(section, key, value, value, Setting.SETTING_TYPE.OPTIONS, -8888, -8888, options))

func add_setting(setting: Setting) -> void:
	pass #settings.append(setting)

# not functional
func remove_setting(_setting_key: String) -> void:
	pass
	#settings.pop_at(settings.bsearch(setting_key))

const MAX_FRAME_RATE: Array = [30, 60, 120, 144, "Unlimited"]
const DISPLAY_STYLE: Array = ["Windowed", "Full Screen", "Borderless Full Screen"]

func apply_settings() -> void:
	for setting in get_children():
		if setting.has_method("apply"):
			setting.apply()
