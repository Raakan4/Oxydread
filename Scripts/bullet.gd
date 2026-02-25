extends Area2D

@export var speed = 1000
var pos : Vector2
var rota : float
var dir : float
var damage : int
var explosive : bool
@onready var sprite = $BulletSprite
@export var texture : Texture2D

func _ready() -> void:
	sprite = texture
	global_position = pos
	global_rotation  = rota
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_delete_timer_timeout() -> void:
	queue_free()
