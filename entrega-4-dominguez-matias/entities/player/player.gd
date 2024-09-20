extends CharacterBody2D
class_name Player

@export var speed:float = 400 
@export var speed_limit:float = 600
@export var jump_speed:float = -400 
@export var acceleration:float = 20
@export var friction_weight:float = 0.5
@export var gravity:float = 20
@export var push_force = 5.0
@onready var body_animation: AnimationPlayer = $BodyAnimation
@onready var body_pivot: Node = $BodyPivot
@onready var weapon_container: Node2D = $WeaponContainer
@onready var staff: Sprite2D = $WeaponContainer/Staff
var can_move: bool = true
var player_camera
var projectile_container

func initialize(container):
	staff.projectile_container = container
	projectile_container = container
	body_animation.play("idle")

func set_camera(camera):
	player_camera = camera

func _get_input():
	var mouse_position = get_global_mouse_position()
	weapon_container.look_at(mouse_position)
	if Input.is_action_just_pressed("fire"):
		staff.fire()
	var h_movement_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * acceleration), -speed_limit, speed_limit)
		body_pivot.scale.x = 1 - 2 * float(h_movement_direction < 0)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction_weight) if abs(velocity.x) > 1 else 0
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed 
	if !is_on_floor():
		if velocity.y > 0:
			_play_animation("fall")
		else:
			_play_animation("jump")
	elif velocity.x != 0:
		_play_animation("walk")
	else:
		_play_animation("idle")

func _physics_process(_delta):
	velocity.y += gravity
	if can_move:
		_get_input()
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func _on_hit_detection_area_entered(area: Area2D) -> void:
	print("player hit")
	collision_layer = 0
	call_deferred("_remove")
	area.delete_requested.emit(area)

func _remove():
	can_move = false
	_play_animation("death")

func _play_animation(animation):
	if body_animation.has_animation(animation):
		body_animation.play(animation)

func _on_body_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		hide()
		velocity.x = 0
