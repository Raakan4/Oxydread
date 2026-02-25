extends States
class_name RegularZombieAttack

@export var enemy : CharacterBody2D
@export var speed : float
@export var target : Node2D = null
var player : CharacterBody2D
@onready var Hitbox = $"../../HitBoxBase"
@onready var DownRayCast = $"../../RayCast2D"
var hitboxresource = load("res://Resource/Hitboxes/RegularZombieHitbox.tres")
var playerlastpos : Vector2
@export var AttackHitbox : Shape2D
@export var Navigation_Agent : NavigationAgent2D
@onready var pathfindingtimer = $"../../PathfindingTimer"
var doubledspeed : int

func enter():
	player = get_tree().get_first_node_in_group("Player")
	target = player
	doubledspeed = enemy.doubledspeed
	call_deferred("set_speed")
	call_deferred("SetupAi")
#	Navigation_Agent.target_position = target.global_position
	Hitbox.hitbox = hitboxresource
	Hitbox.loadhitbox()
	Hitbox.activated = true
	pathfindingtimer.start()
	

func set_speed():
	if enemy.doubledspeed == 1:
		speed = enemy.MovementSpeed * 2
	else:
		speed = enemy.MovementSpeed

func SetupAi():
	Navigation_Agent.target_position = target.global_position

func Physics_Update(delta: float):
	if !Navigation_Agent.is_target_reached():
		var nav_point_direction = enemy.to_local(Navigation_Agent.get_next_path_position()).normalized()
		enemy.velocity = nav_point_direction * speed 
		if enemy.global_position.distance_to(Navigation_Agent.target_position) > 200:
			Transitioned.emit(self,"NewFollow")
			
func _on_pathfinding_timer_timeout() -> void:
	player = get_tree().get_first_node_in_group("Player")
	target = player
	if Navigation_Agent.target_position != target.global_position:
		Navigation_Agent.target_position = target.global_position
	pathfindingtimer.wait_time = 0.3
	pathfindingtimer.start()
