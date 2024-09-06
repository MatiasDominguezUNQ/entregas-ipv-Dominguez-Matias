extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.set_projectile_container(self)
	$Player.set_camera($Player/Camera2D)
