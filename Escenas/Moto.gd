extends CharacterBody2D

const Gravedad : int = 4200
const Jump_V : int = -1800

func _physics_process(delta):
	velocity.y += Gravedad * delta
	if is_on_floor():
		$ColisionSalto.disabled =  true
		$ColisionSalto1.disabled =  true
		$ColisionSalto2.disabled =  true
		$ColisionSalto3.disabled =  true
		$ColisionSalto4.disabled =  true
		$ColisionQuieto.disabled = false
		$ColisionQuieto1.disabled = false
		$ColisionQuieto2.disabled = false
		$ColisionQuieto3.disabled = false
		
		if Input.is_action_pressed("ui_accept"):
			velocity.y = Jump_V
			$"8BitJumpSoundEffect".play()
			$ColisionQuieto.disabled = false
			$ColisionSalto1.disabled =  false
			$ColisionSalto2.disabled =  false
			$ColisionSalto3.disabled =  false
			$ColisionSalto4.disabled =  false
			$ColisionQuieto.disabled = true
			$ColisionQuieto1.disabled = true
			$ColisionQuieto2.disabled = true
			$ColisionQuieto3.disabled = true
		else:
			$AnimatedSprite2D.play("Moto1")
	else:
		$AnimatedSprite2D.play("Salto")	
		
	move_and_slide()
