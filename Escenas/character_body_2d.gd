extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0  # Define una constante para la gravedad

func _physics_process(delta: float) -> void:
	# Aplicar la gravedad en la dirección vertical
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Manejar el salto usando la flecha de arriba
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Obtener la dirección de entrada y manejar el movimiento/desaceleración
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
