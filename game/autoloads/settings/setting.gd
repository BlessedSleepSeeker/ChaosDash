extends Object
class_name Setting

# Class for defining a single setting.

var section: String
var key: String
var value: Variant
var default: Variant

# used only when value is an int
var min_value: int
var max_value: int

var possible_values: Array

func _init(_section: String, _key: String, _value: Variant, _default: Variant,  _min_value: int = 0, _max_value: int = 100, _possible_values: Array = []):
	section = _section
	key = _key
	value = _value
	default = _default
	min_value = _min_value
	max_value = _max_value
	possible_values = _possible_values

func clear() -> void:
	value = null

func reset_to_default() -> void:
	value = default

func get_print_string() -> String:
	return "[%s] %s = %s (default = %s)" % [section, key, value, default]

func set_value(_value: Variant) -> void:
	value = _value
	print_debug("[%s] %s updated to %s" % [section, key, value])