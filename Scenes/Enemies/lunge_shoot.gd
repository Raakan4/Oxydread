extends States
class_name LungeShoot

@export var enemy : CharacterBody2D
@export var speed := 140
@onready var dashparticle = $"../../GPUParticles2D"
@export var intentions = []
var player : CharacterBody2D
var playerlastpos :Vector2
@onready var Hitbox = $"../../HitBoxBase"
var hitboxresource = "res://Resource/Hitboxes/LungeHitbox.tres"
signal reloadhitbox()
const DEFAULT_MODULATE = Color.WHITE
@onready var ShootyPoint = $"../../ShootyPoint"
var spitscene = load("res://Scenes/SpitterSpitScene.tscn")
var projectilespeed = 25.0
var ChargeTime : int
var haslunged = false
var afterspittime = 4

func spit():
	ChargeTime = 1
	player = get_tree().get_first_node_in_group("Player")
	var playerlastpos = player.global_position
	ShootyPoint.look_at(playerlastpos)
	var b = spitscene.instantiate()
	b.target = playerlastpos
	b.pos = enemy.global_position
	b.rota = ShootyPoint.global_rotation
	b.speed = projectilespeed
	owner.add_child(b)
	
func lunge():
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "position", playerlastpos , 0.45)
	Hitbox.loadhitbox()
	Hitbox.look_at(playerlastpos)
	dashparticle.emitting = true
	
	await tween.finished
	haslunged = true
#	Transitioned.emit(self, intentions.pick_random())
#	Hitbox.activated = false	
#	dashparticle.emitting = false

func enter():
	player = get_tree().get_first_node_in_group("Player")
	playerlastpos = player.global_position
	enemy.modulate = DEFAULT_MODULATE
	Hitbox.activated = true
	Hitbox.hitbox = load(hitboxresource)
	
func update(_delta: float):
	if haslunged == true:
		ChargeTime -= 1
		if ChargeTime <= 0 : 
			spit()	
		afterspittime -= 1
		if afterspittime <= 0 : 
			Transitioned.emit(self, intentions.pick_random())
	else:
		pass
func Physics_Update(delta: float):
	lunge()
