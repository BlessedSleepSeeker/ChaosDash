extends HBoxContainer
class_name SettingLine

var lbl: Label
var checkbox: CheckBox
var slider: Slider
var options: OptionButton

@onready var setting_name = $NameContainer/SettingName
@onready var container = $Container

var setting: Setting = null:
	set(val):
		setting = val
		tear_down()
		build()

func tear_down() -> void:
	if lbl != null:
		lbl.queue_free()
	if checkbox != null:
		checkbox.queue_free()
	if slider != null:
		slider.queue_free()
	if options != null:
		options.queue_free()


func build() -> void:
	setting_name.text = setting.key.capitalize()
	if setting.type == setting.SETTING_TYPE.BOOLEAN:
		build_bool()
	elif setting.type == setting.SETTING_TYPE.RANGE:
		build_range()
	elif setting.type == setting.SETTING_TYPE.OPTIONS:
		build_options()


func build_bool() -> void:
	checkbox = CheckBox.new()
	checkbox.button_pressed = setting.value
	container.add_child(checkbox)


func build_range() -> void:
	lbl = Label.new()
	slider = HSlider.new()
	slider.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	slider.value_changed.connect(_on_slider_value_changed)
	container.add_child(slider)
	container.add_child(lbl)
	slider.min_value = setting.min_value
	slider.max_value = setting.max_value
	slider.step = setting.step
	slider.value = setting.value


func _on_slider_value_changed(value: float) -> void:
	lbl.text = String.num(value)


func build_options() -> void:
	options = OptionButton.new()
	for option in setting.possible_values:
		if option is String:
			options.add_item(option)
		elif option is int or option is float:
			options.add_item(String.num(option))
	var value_index = setting.possible_values.find(setting.value)
	options.select(value_index)
	container.add_child(options)


func save() -> void:
	if setting.type == setting.SETTING_TYPE.BOOLEAN:
		setting.value = checkbox.button_pressed
	elif setting.type == setting.SETTING_TYPE.RANGE:
		setting.value = slider.value
	elif setting.type == setting.SETTING_TYPE.OPTIONS:
		setting.value = setting.possible_values[options.get_selected_id()]
