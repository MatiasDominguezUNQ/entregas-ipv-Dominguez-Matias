extends Area2D
class_name Turret

@export var projectile_scene:PackedScene
var turret_container
var target
var timer
var projectile_container
var fire_position

func initialize(container, turret_pos, projectile_container):
	self.turret_container = container
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container

func _ready() -> void:
	fire_position = $FirePosition
	timer = $Timer

func _on_timer_timeout() -> void:
	fire()

func fire():
	var projectile_instance = projectile_scene.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.set_starting_values(fire_position.global_position, (target.global_position - fire_position.global_position).normalized())
	projectile_instance.delete_requested.connect(on_projectile_deleted_requested)

func on_projectile_deleted_requested(projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	target = body
	timer.start()


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		timer.stop()

func _on_area_entered(area: Area2D) -> void:
	turret_container.remove_child(self)
	self.queue_free()
	area.delete_requested.emit(area)
