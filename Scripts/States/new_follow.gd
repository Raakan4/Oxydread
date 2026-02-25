extends States
class_name NewFollow

@export var enemy : CharacterBody2D
@export var target : Node2D = null
@export var speed : float
@export var Intentions = []
var player : CharacterBody2D
@onready var Hitbox = $"../../HitBoxBase"
@onready var DownRayCast = $"../../RayCast2D"
var hitboxresource = load("res://Resource/Hitboxes/RegularZombieHitbox.tres")
var playerpos : Vector2
@export var Navigation_Agent : NavigationAgent2D
@onready var pathfindingtimer = $"../../PathfindingTimer"

func enter():
#	call_deferred("AiSetup")
	Hitbox.hitbox = hitboxresource
	Hitbox.loadhitbox()
	Hitbox.activated = true
	player = get_tree().get_first_node_in_group("Player")
	target = player
	call_deferred("AiSetup")
	#Navigation_Agent.target_position = target.global_position
	call_deferred("SetSpeed")
	pathfindingtimer.start()
	pathfindingtimer.start()
	
func SetSpeed():
	speed = enemy.MovementSpeed
	
func AiSetup():
	Navigation_Agent.target_position = target.global_position
	
func Physics_Update(delta: float):
	#	var direction = player.global_position - enemy.global_position
	if !Navigation_Agent.is_target_reached():
		if enemy.IsBoss == true:
			var nav_point_direction = enemy.to_local(Navigation_Agent.get_next_path_position()).normalized()
			enemy.velocity = nav_point_direction * speed 
			if enemy.global_position.distance_to(Navigation_Agent.target_position) < 400:
				Transitioned.emit(self,Intentions.pick_random())
			if enemy.global_position.distance_to(Navigation_Agent.target_position) > 800:
				speed = 300
			if enemy.global_position.distance_to(Navigation_Agent.target_position) < 800:
				SetSpeed()
				print(speed)
		else:
			var nav_point_direction = enemy.to_local(Navigation_Agent.get_next_path_position()).normalized()
			enemy.velocity = nav_point_direction * speed 
			if enemy.global_position.distance_to(Navigation_Agent.target_position) > 800:
				Transitioned.emit(self,Intentions.pick_random())
func _on_pathfinding_timer_timeout() -> void:
	if Navigation_Agent.target_position != target.global_position:
		Navigation_Agent.target_position = target.global_position
	pathfindingtimer.wait_time = 0.5
	pathfindingtimer.start()
