extends States
class_name Laser

@export var enemy : CharacterBody2D
@export var speed := 0
@onready var dashparticle = $"../../GPUParticles2D"
@export var intentions = []
@export var target : Node2D = null
var player : CharacterBody2D
var playerlastpos :Vector2
@onready var Hitbox = $"../../HitBoxBase"
var hitboxresource = "res://Resource/Hitboxes/LungeHitbox.tres"
var spitscene = load("res://Scenes/LaserOrbScene.tscn")
@onready var pathfindingtimer = $"../../PathfindingTimer"
signal reloadhitbox()
@onready var Shootpoint = $"../../ShootPos"
@export var NavigationAgent : NavigationAgent2D
@onready var main = get_tree().get_root()
var ChargeTime = 300 

func ShootLaser(Damage):
	playerlastpos = target.global_position
	Shootpoint.look_at(playerlastpos)
	var b = spitscene.instantiate()
	b.target = playerlastpos
	b.pos = enemy.global_position
	b.rota = Shootpoint.global_rotation
	owner.add_child(b)
	print("pew")

func enter():
	player = get_tree().get_first_node_in_group("Player")
	target = player
	Hitbox.hitbox = load(hitboxresource)
	
func update(delta: float):
	ChargeTime -= 1
	if ChargeTime <= 0 : 
		ShootLaser(10)
		ChargeTime = 300
		
func Physics_Update(delta: float):
	if !NavigationAgent.is_target_reached():
		var nav_point_direction = enemy.to_local(NavigationAgent.get_next_path_position()).normalized()
		enemy.velocity = nav_point_direction * speed 
	if enemy.global_position.distance_to(player.global_position) > 850:
		Transitioned.emit(self,intentions.pick_random())
