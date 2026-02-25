extends States
class_name RetreatRegular

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
var retreattime = 2

func enter():
	player = get_tree().get_first_node_in_group("Player")
	target = player
	Navigation_Agent.target_position = target.global_position
	call_deferred("SetSpeed")
	Hitbox.hitbox = hitboxresource
	Hitbox.loadhitbox()
	Hitbox.activated = true
	enemy.set_collision_layer_value(1, true)
	enemy.set_collision_mask_value(1, true)
	
func SetSpeed():
	speed = enemy.MovementSpeed
	
func AiSetup():
	Navigation_Agent.target_position = target.global_position
	
func Physics_Update(delta: float):
	#	var direction = player.global_position - enemy.global_position
	if !Navigation_Agent.is_target_reached():
		var nav_point_direction = enemy.to_local(Navigation_Agent.get_next_path_position()).normalized() * -1
		var navpointoppositex = nav_point_direction * -1
		enemy.velocity = nav_point_direction * speed 
		#print(enemy.global_position.distance_to(Navigation_Agent.target_position))
		if enemy.global_position.distance_to(Navigation_Agent.target_position) > 300:
			Transitioned.emit(self,"NewFollow")
			enemy.set_collision_layer_value(1, false)
			enemy.set_collision_mask_value(1, false)

func update(_delta: float):
	if retreattime > 0:
		retreattime -= _delta
	else:
		Transitioned.emit(self,"NewFollow")
		enemy.set_collision_layer_value(1, false)
		enemy.set_collision_mask_value(1, false)

func _on_pathfinding_timer_timeout() -> void:
	if Navigation_Agent.target_position != target.global_position:
		Navigation_Agent.target_position = target.global_position
	pathfindingtimer.start()
