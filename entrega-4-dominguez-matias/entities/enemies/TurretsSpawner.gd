extends Node

@export var turret_scene:PackedScene 

func _ready() -> void:
	call_deferred("initialize")

func initialize():
	var centerpos = $TurretSpawnArea.global_position
	var size = $TurretSpawnArea/TurretSpawnShape.shape.extents * 2
	for i in 3:
		var turret_instance = turret_scene.instantiate()
		var random_x = randf_range(centerpos.x - size.x / 2, centerpos.x + size.x / 2)
		var random_y = randf_range(centerpos.y - size.y / 2, centerpos.y + size.y / 2)
		var turret_pos = Vector2(random_x, random_y)
		turret_instance.initialize(self, turret_pos, self)
