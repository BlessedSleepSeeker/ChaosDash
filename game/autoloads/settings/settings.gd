extends Node

@export var userControlFilePath: String = "user://settings/gameSettings.cfg"

#setting file path
@onready var settings_file := ConfigFile.new()

@onready var settings: Array = [] 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

## Settings Getters

func get_sections() -> Array:
	var sections: Array = []
	for sett in settings:
		if !sections.has(sett.section):
			sections.append(sett.section)
	return sections

func get_settings_by_section(section: String) -> Array:
	var settings_by_section: Array = []
	for sett in settings:
		if sett.section == section:
			settings_by_section.append(sett)
	return settings_by_section

## File interaction

func change_settings_file_path(new_path: String) -> void:
	userControlFilePath = new_path

func load_file() -> int:
	var err = settings_file.load(userControlFilePath)
	if err != OK:
		printerr("Something happened at %s, error code [%d]" % [userControlFilePath, err])
	return err


func load_from_file() -> void:
	load_file()
	for setting in settings:
		#printerr(settings_file.has_section(setting.section))
		#printerr(settings_file.has_section_key(setting.section, setting.key))
		if settings_file.has_section(setting.section) and settings_file.has_section_key(setting.section, setting.key):
			setting.value = get_value(setting.section, setting.key)

# save_to_file() will load the file at the current path and modify the value inside, then write it.
# we need to call save_to_file() only when the settings are modified
func save_to_file() -> int:
	print_debug('Saving file at %s' % userControlFilePath)

	load_file()

	for setting in settings:
		set_value(setting.section, setting.key, setting.value)

	var err = settings_file.save(userControlFilePath)
	if err != OK:
		printerr("Error code [%d]. Something went wrong saving the file at %s." % [err, userControlFilePath])
	return err

func get_value(section: String, setting: String) -> Variant:
	return settings_file.get_value(section, setting, "")

func set_value(section: String, setting: String, value: Variant) -> void:
	settings_file.set_value(section, setting, value)

## Settings Interaction

func print_settings() -> void:
	for seti in settings:
			print_debug(seti.get_print_string())

func create_setting(section: String, key: String, value: Variant): #automaticaly set the default value to the value you give him at creation
	add_setting(Setting.new(section, key, value, value))

func add_setting(setting: Setting) -> void:
	settings.append(setting)

# not functional
func remove_setting(_setting_key: String) -> void:
	pass
	#settings.pop_at(settings.bsearch(setting_key))
