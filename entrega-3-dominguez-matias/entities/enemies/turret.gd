extends Area2D
class_name Turret

@export var projectile_scene:PackedScene
var turret_container
var target
var timer
var projectile_container
var fire_position
var raycast

func initialize(container, turret_pos, projectile_container):
	self.turret_container = container
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container

func _ready() -> void:
	fire_position = $FirePosition
	timer = $Timer
	raycast = $RayCast2D
	set_physics_process(false)

func _on_timer_timeout() -> void:
	fire()

func fire():
	var projectile_instance = projectile_scene.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.set_starting_values(fire_position.global_position, (target.global_position - fire_position.global_position).normalized())
	projectile_instance.delete_requested.connect(on_projectile_deleted_requested)

func on_projectile_deleted_requested(projectile):
	projectile_container.call_deferred("remove_child", projectile)
	projectile.call_deferred("queue_free")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if target == null:
		target=body
		set_physics_process(true)


func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null
		set_physics_process(false)

func _on_area_entered(area: Area2D) -> void:
	turret_container.remove_child(self)
	self.queue_free()
	area.delete_requested.emit(area)

func _physics_process(delta):
	if is_instance_valid(target):
		raycast.target_position = to_local(target.global_position)
		if raycast.is_colliding() && raycast.get_collider() == target:
			if timer.is_stopped():
				timer.start()
		elif !timer.is_stopped():
			timer.stop()
	else:
		if !timer.is_stopped():
			timer.stop()
