extends Sprite2D
var fire_position
var projectile_container
var can_fire: bool = true
@export var projectile_scene:PackedScene
@onready var fire_cooldown: Timer = $FireCooldown

func _ready() -> void:
	fire_position = $FirePosition

func fire():
	if can_fire:
		can_fire = false
		fire_cooldown.start()
		var projectile_instance = projectile_scene.instantiate()
		fire_position.add_child(projectile_instance)
		projectile_instance._play_animation("fire_start")
		projectile_instance.delete_requested.connect(on_projectile_deleted_requested)
		projectile_instance.fire_animation_ended.connect(on_fire_animation_ended)

func on_projectile_deleted_requested(projectile):
	projectile_container.call_deferred("remove_child", projectile)
	projectile.call_deferred("_play_animation", "hit")

func on_fire_animation_ended(projectile):
	var mouse_position = get_global_mouse_position()
	projectile.reparent(projectile_container)
	projectile.set_starting_values(fire_position.global_position, (fire_position.global_position - global_position).normalized(), mouse_position)

func _on_fire_cooldown_timeout() -> void:
	can_fire = true
