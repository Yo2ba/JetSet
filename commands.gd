extends Control

@export var cmd: LineEdit
@onready var output_script = preload("res://output.gd")

var str_history: Array[String] = []
var str_history_pos: int = 0

func _execute(command) -> void:
	if _has_script_method(command):
		call(command)
	else:
		_unknown_command(command)

func _has_script_method(method_name: String) -> bool:
	var script = get_script()
	if script == null:
		return false
	for i in script.get_script_method_list():
		if i.name == method_name and not i.name.begins_with("_"):
			return true
	return false


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('ui_text_submit') and cmd.text.strip_edges() != "":
		var text = cmd.text.strip_edges()
		_execute(text)
		
		if str_history.size() == 0 or str_history[str_history.size() - 1] != text:
			str_history.append(text)
			if str_history.size() > 50:
				str_history.pop_front()
		cmd.text = ""
		str_history_pos = -1
	
	if Input.is_action_just_pressed('ui_up'):
		if str_history.size() > 0 and str_history_pos < str_history.size() - 1:
			str_history_pos += 1
			cmd.text = str_history[str_history.size() - 1 - str_history_pos]
	
	if Input.is_action_just_pressed('ui_down'):
		if str_history_pos > 0:
			str_history_pos -= 1
			cmd.text = str_history[str_history.size() - 1 - str_history_pos]
		elif str_history_pos == 0:
			str_history_pos = -1
			cmd.text = ""


func help() -> void:
	var script = get_script()
	var command_list := []
	for i in script.get_script_method_list():
		if not i.name.begins_with("_") and not i.name == "help":
			command_list.append(i.name)
	command_list.sort()
	
	for i in command_list:
		print(i)

func _unknown_command(command) -> void:
	print("Unknown command: ", command)
	_output("Unknown command: " + command)

func _output(text: String) -> void:
	var output = Label.new()
	output.text = text
	output.global_position = Vector2(4, cmd.global_position.y - 20)
	output.set_script(output_script)
	add_child(output)

#commands___________________________________________________________
#!!! do not use the prefix _ since it encapsulates methods

func hello() -> void:
	_output("Oh, Hi!")

func hi() -> void:
	pass

func quit() -> void:
	get_tree().quit()

func jump() -> void:
	print("Boink!")
	_output("Boink!")

func up() -> void:
	cmd.global_position.y -= 10

func down() -> void:
	cmd.global_position.y += 10
