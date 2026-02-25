extends States
class_name SummonState

@export var enemy : CharacterBody2D
@export var target : Node2D = null
@export var speed = 0
@export var Intentions = []
var player : CharacterBody2D
var hitboxresource = load("res://Resource/Hitboxes/RegularZombieHitbox.tres")
var playerpos : Vector2
@export var Navigation_Agent : NavigationAgent2D
@onready var pathfindingtimer = $"../../PathfindingTimer"
@onready var enemysprite = $"../../EnemySprite"
var WaitTime = randf_range(1,2)
@onready var Hitbox = $"../../HitBoxBase"
@onready var spawnpoints = []
 
func summon():
	for i in spawnpoints:
		i.SpawnEnemy()

func enter():
#	call_deferred("AiSetup")
	player = get_tree().get_first_node_in_group("Player")
	WaitTime = randf_range(1,2.5)
	spawnpoints = get_tree().get_nodes_in_group("BossSpawnPoint")
	target = player
	Hitbox.hitbox = hitboxresource
	Hitbox.loadhitbox()
	Hitbox.activated = true

func update(delta: float):
	if WaitTime > 0:
		WaitTime -= delta
	else:
		summon()
		Transitioned.emit(self, Intentions.pick_random())

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
		
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * speed
	else:
		enemy.velocity = Vector2()
