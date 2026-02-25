extends States
class_name LungeAttack

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

func lunge():
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "position", playerlastpos , 0.45)
	Hitbox.loadhitbox()
	Hitbox.look_at(playerlastpos)
	dashparticle.emitting = true
	
	await tween.finished
	Transitioned.emit(self, intentions.pick_random())
	Hitbox.activated = false	
	dashparticle.emitting = false

func enter():
	player = get_tree().get_first_node_in_group("Player")
	playerlastpos = player.global_position
	enemy.modulate = DEFAULT_MODULATE
	print(playerlastpos)
	Hitbox.activated = true
	Hitbox.hitbox = load(hitboxresource)
	
func Physics_Update(delta: float):
	lunge()
