extends Sprite2D
class_name Turret

@export var projectile_scene:PackedScene
var player
var projectile_container
var fire_position

func set_values(player, projectile_container):
	self.player = player
	self.projectile_container = projectile_container
	$Timer.start()

func _ready() -> void:
	fire_position = $FirePosition

func _on_timer_timeout() -> void:
	fire()

func fire():
	var projectile_instance = projectile_scene.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.set_starting_values(fire_position.global_position, (player.global_position - fire_position.global_position).normalized())
	projectile_instance.delete_requested.connect(on_projectile_deleted_requested)

func on_projectile_deleted_requested(projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()
