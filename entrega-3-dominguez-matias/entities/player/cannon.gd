extends Sprite2D
var fire_position
var projectile_container
@export var projectile_scene:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fire_position = $FirePosition

func fire():
	var projectile_instance = projectile_scene.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.set_starting_values(fire_position.global_position, (fire_position.global_position - global_position).normalized())
	projectile_instance.delete_requested.connect(on_projectile_deleted_requested)

func on_projectile_deleted_requested(projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()
