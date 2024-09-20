extends Area2D
class_name Projectile
signal delete_requested(projectile)
signal fire_animation_ended(projectile)

var direction
@export var projectile_speed:float
@onready var projectile_animation: AnimatedSprite2D = $ProjectileAnimation
@onready var projectile_shape: CollisionShape2D = $ProjectileShape

func _ready():
	set_physics_process(false)

func set_starting_values(starting_position, direction, projectile_direction):
	global_position = starting_position
	self.direction = direction
	self.look_at(projectile_direction)
	projectile_shape.disabled = false
	set_physics_process(true)
	_play_animation("fire_loop")
	$Timer.start()

func _physics_process(delta):
	position += direction*projectile_speed*delta

func _on_timer_timeout() -> void:
	_play_animation("hit")
	set_physics_process(false)

func _on_body_entered(body: Node2D) -> void:
	_play_animation("hit")
	set_physics_process(false)

func _play_animation(animation):
	projectile_animation.play(animation)

func _on_projectile_animation_finished() -> void:
	if projectile_animation.animation == "fire_start":
		fire_animation_ended.emit(self)
	elif projectile_animation.animation == "hit":
		delete_requested.emit(self)
