extends CharacterBody2D
class_name Player

@export var speed:float = 400 
@export var speed_limit:float = 600
@export var jump_speed:float = -400 
@export var acceleration:float = 20
@export var friction_weight:float = 0.5
@export var gravity:float = 20
@export var push_force = 5.0
var cannon
var player_camera
var projectile_container

func set_projectile_container(container):
	cannon.projectile_container = container
	projectile_container = container

func set_camera(camera):
	player_camera = camera

func _ready() -> void:
	cannon = $Cannon

func _get_input():
	var mouse_position = get_global_mouse_position()
	cannon.look_at(mouse_position)
	if Input.is_action_just_pressed("fire"):
		cannon.fire()
	velocity.y += gravity
	var h_movement_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * acceleration), -speed_limit, speed_limit)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction_weight) if abs(velocity.x) > 1 else 0
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed 

func _physics_process(_delta):
	_get_input()
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func _on_hit_detection_area_entered(area: Area2D) -> void:
	print("player hit")
	call_deferred("_remove")
	area.delete_requested.emit(area)

func _remove():
	var camera_position = player_camera.global_position
	player_camera.get_parent().remove_child(player_camera)
	get_tree().root.add_child(player_camera)
	player_camera.global_position = camera_position
	self.queue_free()
