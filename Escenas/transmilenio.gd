extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(delta):
	position.x -= get_parent().speed /2
