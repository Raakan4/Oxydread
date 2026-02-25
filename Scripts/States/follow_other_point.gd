extends States
class_name Follow_other_point

@export var enemy : CharacterBody2D
@export var target : Node2D = null
@export var speed : float
@export var Intentions = []
var player : CharacterBody2D
@onready var Hitbox = $"../../HitBoxBase"
@onready var DownRayCast = $"../../RayCast2D"
var hitboxresource = "res://Resource/Hitboxes/LungeHitbox.tres"
var playerpos : Vector2
@export var Navigation_Agent : NavigationAgent2D
@onready var pathfindingtimer = $"../../PathfindingTimer"

func enter():
#	call_deferred("AiSetup")
	player = get_tree().get_first_node_in_group("Player")
	var pickretreatnode = player.RetreatNodes.pick_random()
	target = pickretreatnode
	call_deferred("AiSetup")
	#Navigation_Agent.target_position = target.global_position
	call_deferred("SetSpeed")
	
func SetSpeed():
	speed = enemy.MovementSpeed
	
func AiSetup():
	Navigation_Agent.target_position = target.global_position
	
func Physics_Update(delta: float):
	#	var direction = player.global_position - enemy.global_position
	if !Navigation_Agent.is_target_reached():
		var nav_point_direction = enemy.to_local(Navigation_Agent.get_next_path_position()).normalized()
		enemy.velocity = nav_point_direction * speed 
		#print(enemy.global_position.distance_to(Navigation_Agent.target_position))
		if enemy.global_position.distance_to(Navigation_Agent.target_position) < 100:
			Transitioned.emit(self,Intentions.pick_random())

func _on_pathfinding_timer_timeout() -> void:
	player = get_tree().get_first_node_in_group("Player")
	target = player
	if Navigation_Agent.target_position != target.global_position:
		Navigation_Agent.target_position = target.global_position
	pathfindingtimer.start()
