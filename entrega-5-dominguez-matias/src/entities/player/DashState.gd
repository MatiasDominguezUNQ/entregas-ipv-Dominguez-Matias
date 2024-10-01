extends AbstractState


var dash_timer: float = 0.0

func enter() -> void:
	dash_timer = character.dash_duration
	if character.velocity.x != 0:
		character.velocity.x = (1 - 2 * float(character.velocity.x < 0)) * character.dash_speed

func update(delta: float) -> void:
	dash_timer -= delta
	character._apply_movement()
	if dash_timer <= 0:
		if character.is_on_floor_custom():
			if character.move_direction == 0:
				emit_signal("finished", "idle")
			else:
				emit_signal("finished", "walk")
		else:
			if character.velocity.y > 0:
				character._play_animation("fall")
			else:
				character._play_animation("jump")

func handle_input(event: InputEvent) -> void:
	pass

func exit() -> void:
	character.velocity.x = 0
