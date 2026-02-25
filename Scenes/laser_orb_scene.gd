extends Area2D

@export var speed = 5
var pos : Vector2
var rota : float
var dir : float
var damage : int
var target : Vector2
@export var HitboxShape : Shape2D
var explode = load("res://Scenes/OrbExplosion.tscn")

func _ready() -> void:
	global_position = pos
	global_rotation = rota
	
func _physics_process(delta: float) -> void:
	global_position += transform.x * speed * delta

func _on_delete_timer_timeout() -> void:
	var explodenode = explode.instantiate()
	explodenode.global_position = global_position
	var root = get_tree().get_root()
	root.add_child(explodenode)
	queue_free()
