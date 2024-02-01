extends Node
class_name Setting

# Class for defining a single setting.
@export_group("Mandatory")
@export var section: String
@export var key: String
var value: Variant
var default: Variant

enum SETTING_TYPE {
	BOOLEAN,
	RANGE,
	OPTIONS,
}

@export var type: SETTING_TYPE = SETTING_TYPE.BOOLEAN

# used only when value is an int

@export_group("Only when type is range")
@export var min_value: int
@export var max_value: int

var pos_values_str: String = ""

@export_group("Only when type is option")
@export var possible_values: Array:
	set(val):
		possible_values = val

func _init(_section: String, _key: String, _value: Variant, _default: Variant, _type: int = SETTING_TYPE.BOOLEAN, _min_value: int = -8888, _max_value: int = -8888, _possible_values: Array = []):
	section = _section
	key = _key
	value = _value
	default = _default
	type = _type as SETTING_TYPE
	min_value = _min_value
	max_value = _max_value
	possible_values = _possible_values

func clear() -> void:
	value = null

func reset_to_default() -> void:
	value = default

func get_print_string() -> String:
	return "[%s] %s = %s (default = %s) (type = %d)" % [section, key, value, default, type]

func set_value(_value: Variant) -> void:
	value = _value
	print_debug("[%s] %s updated to %s" % [section, key, value])