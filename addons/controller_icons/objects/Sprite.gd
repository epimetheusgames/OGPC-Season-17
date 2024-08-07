extends Sprite2D
class_name ControllerSprite2D

@export var path : String = "":
	set(_path):
		path = _path
		if is_inside_tree():
			if force_type > 0:
				texture = ControllerIcons.parse_path(path, force_type - 1)
			else:
				texture = ControllerIcons.parse_path(path)

@export_enum("Both", "Keyboard/Mouse", "Controller") var show_only : int = 0:
	set(_show_only):
		show_only = _show_only
		_on_input_type_changed(ControllerIcons._last_input_type)

@export_enum("None", "Keyboard/Mouse", "Controller") var force_type : int = 0:
	set(_force_type):
		force_type = _force_type
		_on_input_type_changed(force_type)

func _ready():
	ControllerIcons.input_type_changed.connect(_on_input_type_changed)
	self.path = path
	
func _process(delta):
	if len(Input.get_connected_joypads()) > 0:
		force_type = 2
		texture = ControllerIcons.parse_path(path, 1)
	else:
		force_type = 1
		texture = ControllerIcons.parse_path(path, 0)

func _on_input_type_changed(input_type):
	pass

func get_tts_string() -> String:
	return "no."
