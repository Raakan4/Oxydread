extends States
class_name Spit

@export var enemy : CharacterBody2D
@export var speed := 0
@onready var dashparticle = $"../../GPUParticles2D"
@export var intentions = []
@export var target : Node2D = null
var player : CharacterBody2D
var playerlastpos :Vector2
@onready var Hitbox = $"../../HitBoxBase"
var hitboxresource = "res://Resource/Hitboxes/LungeHitbox.tres"
var spitscene = load("res://Scenes/SpitterSpitScene.tscn")
@onready var pathfindingtimer = $"../../PathfindingTimer"
signal reloadhitbox()
@onready var Shootpoint = $"../../ShootPos"
@export var NavigationAgent : NavigationAgent2D
@onready var main = get_tree().get_root()
var ChargeTime = 3 
const DEFAULT_MODULATE = Color.WHITE

func spit(Damage):
	playerlastpos = target.global_position
	Shootpoint.look_at(playerlastpos)
	var b = spitscene.instantiate()
	b.target = playerlastpos
	b.pos = enemy.global_position
	b.rota = Shootpoint.global_rotation
	b.speed = enemy._ProjectileSpeed
	owner.add_child(b)
	print("spit")

func enter():
	player = get_tree().get_first_node_in_group("Player")
	target = player
	enemy.modulate = DEFAULT_MODULATE
	spit(0)
	ChargeTime = 3 
	Hitbox.hitbox = load(hitboxresource)
	
func update(delta: float):
	ChargeTime -= 1
	if ChargeTime <= 0 : 
		Transitioned.emit(self,"SpitChargeUp")
		ChargeTime = 3
		
func Physics_Update(delta: float):
	if !NavigationAgent.is_target_reached():
		var nav_point_direction = enemy.to_local(NavigationAgent.get_next_path_position()).normalized()
		enemy.velocity = nav_point_direction * speed 
	if enemy.global_position.distance_to(player.global_position) > 750:
		Transitioned.emit(self,intentions.pick_random())
