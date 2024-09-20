extends RigidBody2D
class_name Turret

@export var projectile_scene:PackedScene
@export var gravity:float = 20
var turret_container
var target
var projectile_container
var is_dead = false
var velocity = Vector2(0, 0)
@onready var body_anim: AnimatedSprite2D = $Body
@onready var fire_position: Marker2D = $FirePosition
@onready var timer: Timer = $Timer
@onready var raycast: RayCast2D = $RayCast2D
@onready var hit_detection: Area2D = $HitDetection

func initialize(container, turret_pos, projectile_container):
	self.turret_container = container
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container
	_play_animation("idle")

func _ready() -> void:
	set_physics_process(false)

func _on_timer_timeout() -> void:
	fire()

func fire():
	var projectile_instance = projectile_scene.instantiate()
	fire_position.add_child(projectile_instance)
	projectile_instance._play_animation("fire_start")
	projectile_instance.delete_requested.connect(on_projectile_deleted_requested)
	projectile_instance.fire_animation_ended.connect(on_fire_animation_ended)

func on_fire_animation_ended(projectile):
	projectile.reparent(projectile_container)
	projectile.set_starting_values(fire_position.global_position, (target.global_position - fire_position.global_position).normalized(), target.global_position)
	

func on_projectile_deleted_requested(projectile):
	projectile_container.call_deferred("remove_child", projectile)
	projectile.call_deferred("_play_animation", "hit")


func _on_detection_area_body_entered(body: Node2D) -> void:
	if target == null:
		target=body
		set_physics_process(true)


func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null
		set_physics_process(false)

func _physics_process(delta):
	if is_dead:
		timer.stop()
		velocity.y += gravity * delta
		move_and_collide(velocity)
	else:
		if is_instance_valid(target):
			raycast.target_position = to_local(target.global_position)
			if raycast.is_colliding() && raycast.get_collider() == target:
				if timer.is_stopped():
					_play_animation("attack")
					timer.start()
			elif !timer.is_stopped():
				_play_animation("idle")
				timer.stop()
		else:
			if !timer.is_stopped():
				timer.stop()

func _play_animation(animation):
	if body_anim.sprite_frames.has_animation(animation):
		body_anim.play(animation)
		


func _on_hit_detection_area_entered(hit):
	is_dead = true
	_play_animation("death")
	hit.delete_requested.emit(hit)
	hit_detection.collision_mask = 0
