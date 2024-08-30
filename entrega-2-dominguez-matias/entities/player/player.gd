extends Area2D

@export var speed = 400 
var screen_size 
var player_size
var cannon
var projectile_container

func set_projectile_container(container):
	cannon.projectile_container = container
	projectile_container = container

func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_size = $CollisionShape2D.shape.get_rect().size
	cannon = $Cannon

func _process(delta):
	var mouse_position = get_global_mouse_position()
	cannon.look_at(mouse_position)
	if Input.is_action_just_pressed("fire"):
		cannon.fire()
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO+player_size/2, screen_size-player_size/2)
