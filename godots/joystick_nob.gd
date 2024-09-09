extends Sprite2D

@onready var parent = $".."

var is_nob_pressed: bool = false

@export var max_nob_length = 65
var deadzone = 10


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if not is_nob_pressed:
		global_position = lerp(global_position, parent.global_position, delta*50)
		parent.joystick_position = Vector2(0,0)
		return
	
	var click_position = get_global_mouse_position()
	var click_distance = click_position.distance_to(parent.global_position)
	
	if click_distance <= max_nob_length:
		global_position = click_position
	else:
		var angle = parent.global_position.angle_to_point(get_global_mouse_position())
		global_position.x = parent.global_position.x + cos(angle) * max_nob_length
		global_position.y = parent.global_position.y + sin(angle) * max_nob_length
		
	calculate_vector()


func _on_button_button_up() -> void:
	is_nob_pressed = false


func _on_button_button_down() -> void:
	is_nob_pressed = true


func calculate_vector():
	for axis in range(2):
		var delta = global_position[axis] - parent.global_position[axis]
		if abs(delta) >= deadzone:
			parent.joystick_position[axis] = delta / max_nob_length
