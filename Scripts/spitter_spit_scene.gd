extends Area2D

@export var speed : float
var pos : Vector2
var rota : float
var dir : float
var damage : int
var target : Vector2
@export var HitboxShape : Shape2D

func _ready() -> void:
	global_position = pos
	global_rotation = rota
	var hitbox = HitboxRewite.new(15, 5, HitboxShape, 1, 30)
	hitbox.deleteonhit = true
	hitbox.source = self
	add_child(hitbox)
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_delete_timer_timeout() -> void:
	queue_free()
