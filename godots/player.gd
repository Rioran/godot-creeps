extends Area2D

@onready var joystick = $"../HUD/joystick"
@onready var player = $"."

signal hit

@export var speed = 400
var screen_size

const MOVES_VECTORS = {
	'move_right': Vector2(1, 0),
	'move_left': Vector2(-1, 0),
	'move_down': Vector2(0, 1),
	'move_up': Vector2(0, -1),
}


func _ready():
	screen_size = get_viewport_rect().size
	hide()
	$AnimatedSprite2D.animation = "up"

func _process(delta):
	var velocity = Vector2.ZERO
	var direction = joystick.joystick_position
	
	if not direction:
		$AnimatedSprite2D.stop()
		return
		
	$AnimatedSprite2D.play()
	player.rotation = direction.angle() + PI / 2
	
	velocity = direction * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_exited(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
