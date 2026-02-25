extends States
class_name RegularZombieFollow

@export var enemy : CharacterBody2D
@export var target : Node2D = null
@export var speed := 30
var player : CharacterBody2D
@onready var Hitbox = $"../../HitBoxBase"
@onready var DownRayCast = $"../../RayCast2D"
var hitboxresource = "res://Resource/Hitboxes/LungeHitbox.tres"
var playerpos : Vector2
@export var Navigation_Agent : NavigationAgent2D

func enter():
	call_deferred("AiSetup")
	player = get_tree().get_first_node_in_group("Player")
	Hitbox.activated = true
	target = player

func AiSetup():
	await get_tree().physics_frame
	if target:
		Navigation_Agent.target_position = target.global_position
	
func Physics_Update(delta: float):
		var direction = player.global_position - enemy.global_position
		
		#if Navigation_Agent:
	#	if Navigation_Agent.is_navigation_finished():
	#		return
	#	var current_agent_position = enemy.global_position
	#	var nextpathposition = Navigation_Agent.get_next_path_position()
	#	enemy.velocity = current_agent_position.direction_to(nextpathposition) * speed
			
#		else:
		if direction.length() > 25:
			enemy.velocity = direction.normalized() * speed
		else:
			enemy.velocity = Vector2()
		playerpos = player.global_position
		#Hitbox.look_at(playerpos)
		if direction.length() > 600:
			Transitioned.emit(self, "")
		if direction.length() < 200:
			Transitioned.emit(self, "Attack")
	#if DownRayCast.is_colliding():
	#	Transitioned.emit(self, "UnstuckFromPlayer")
