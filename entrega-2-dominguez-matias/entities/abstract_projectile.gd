extends Sprite2D
class_name Projectile
signal delete_requested(projectile)

var direction
@export var projectile_speed:float

func _ready():
	set_physics_process(false)

func set_starting_values(starting_position, direction):
	global_position = starting_position
	self.direction = direction
	$Timer.start()
	set_physics_process(true)

func _physics_process(delta):
	position += direction*projectile_speed*delta


func _on_timer_timeout() -> void:
	delete_requested.emit(self)
