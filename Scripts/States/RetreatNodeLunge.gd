extends Node2D
@onready var sprite = $"../EnemySprite"

func _process(delta: float) -> void:
	if sprite.flip_h == true:
		self.position.x *= -1
	if sprite.flip_h == false:
		self.position.x *= 1
