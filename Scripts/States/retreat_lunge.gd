extends States
class_name RetreatLunge

@export var enemy : CharacterBody2D
@export var speed := 140
@onready var dashparticle = $"../../GPUParticles2D"
@export var intentions = []
@export var RetreatNodes : Array[Node2D] = []
var player : CharacterBody2D
var playerlastpos :Vector2
@onready var Hitbox = $"../../HitBoxBase"
var hitboxresource = "res://Resource/Hitboxes/LungeHitbox.tres"
signal reloadhitbox()
var pickretreatnode : Node2D
const DEFAULT_MODULATE = Color.WHITE

func lunge():
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "position", pickretreatnode.global_position , 0.5)
	Hitbox.loadhitbox()
	Hitbox.look_at(pickretreatnode.global_position)
	dashparticle.emitting = true
	await tween.finished
	Transitioned.emit(self, intentions.pick_random())
	Hitbox.activated = false	
	dashparticle.emitting = false

func enter():
	enemy.modulate = DEFAULT_MODULATE
	Hitbox.activated = true
	Hitbox.hitbox = load(hitboxresource)
	player = get_tree().get_first_node_in_group("Player")
	#pickretreatnode = enemy.retreatpoints.pick_random()
	pickretreatnode = player.RetreatNodes.pick_random()
	call_deferred("lunge")
	
	
func Physics_Update(delta: float):
	#lunge()
	return
