extends AbstractState

@export var jumps_limit: int = 1
var jumps: int = 0

func enter() -> void:
	character.snap_vector = Vector2.ZERO
	character.velocity.y -= character.jump_speed 
	character._play_animation("jump")

func exit():
	jumps = 0

func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") && jumps < jumps_limit:
		jumps += 1
		character.velocity.y = -character.jump_speed
		character._play_animation("jump")
	if Input.is_action_just_pressed("dash"):
		emit_signal("finished", "dash")


# En esta función vamos a manejar las acciones apropiadas para este estado
func update(delta: float) -> void:
	character._handle_weapon_actions()
	character._handle_move_input()
	if character.move_direction == 0:
		character._handle_deacceleration()
	character._apply_movement()
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

# En este callback manejamos, por el momento, solo los impactos
func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			character._handle_hit(value)
			if character.is_dead:
				emit_signal("finished", "dead")
