extends States
class_name GotoPointwhileShooting

@export var enemy : CharacterBody2D
@export var target : Node2D = null
@export var speed = 300
@export var Intentions = []
var player : CharacterBody2D
@onready var Hitbox = $"../../HitBoxBase"
@onready var DownRayCast = $"../../RayCast2D"
var hitboxresource = "res://Resource/Hitboxes/LungeHitbox.tres"
var playerpos : Vector2
@export var Navigation_Agent : NavigationAgent2D
@onready var pathfindingtimer = $"../../PathfindingTimer"
var runpoints = []
@onready var ShootyPoint = $"../../ShootyPoint"
var spitscene = load("res://Scenes/SpitterSpitScene.tscn")
var projectilespeed = 25.0
var ChargeTime : int

func enter():
	ChargeTime = 30
	runpoints = get_tree().get_nodes_in_group("BossRunPoint")
	player = get_tree().get_first_node_in_group("Player")
	var random_int = randi_range(0, runpoints.size() - 1)
	target = runpoints[random_int]
	call_deferred("AiSetup")
	print("nigga")
	print(runpoints)
	pathfindingtimer.start()

func spit():
	ChargeTime = 30
	player = get_tree().get_first_node_in_group("Player")
	var playerlastpos = player.global_position
	ShootyPoint.look_at(playerlastpos)
	var b = spitscene.instantiate()
	b.target = playerlastpos
	b.pos = enemy.global_position
	b.rota = ShootyPoint.global_rotation
	b.speed = projectilespeed
	owner.add_child(b)
	
func SetSpeed():
	speed = enemy.MovementSpeed
	
func AiSetup():
	Navigation_Agent.target_position = target.global_position
	
func Physics_Update(delta: float):
#	var direction = player.global_position - enemy.global_position
	if !Navigation_Agent.is_target_reached():
		Navigation_Agent.target_position = target.global_position
		var nav_point_direction = enemy.to_local(Navigation_Agent.get_next_path_position()).normalized()
		enemy.velocity = nav_point_direction * speed 
		if enemy.global_position.distance_to(Navigation_Agent.target_position) < 50:
			print("ran")
			Transitioned.emit(self,Intentions.pick_random())
	else:
		print("nigga")

func update(_delta: float):
	ChargeTime -= 1
	if ChargeTime <= 0 : 
		spit()
	
func _on_pathfinding_timer_timeout() -> void:
	if Navigation_Agent.target_position != target.global_position:
		Navigation_Agent.target_position = target.global_position
	pathfindingtimer.wait_time = 0.5
	pathfindingtimer.start()
