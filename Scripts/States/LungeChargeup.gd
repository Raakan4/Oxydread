extends States
class_name EnemyLungeChargeup

@export var enemy: CharacterBody2D
@export var ChargeTime := 60
var player : CharacterBody2D
@onready var AttackTimer = $AttackTimer
@onready var Sprite = $EnemySprite
@export var intentions = []
const DEFAULT_MODULATE = Color.WHITE

func LungeChargeup(time):
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "modulate", Color.RED , time)
	await tween.finished
	Transitioned.emit(self, intentions.pick_random())
	
func enter():
	LungeChargeup(1)

#func update(delta: float):
	#ChargeTime -= 1
	#if ChargeTime <= 0 : 
	#	Transitioned.emit(self, intentions.pick_random())
	#print(ChargeTime)
		
func Physics_Update(delta: float):
	enemy.velocity = Vector2.ZERO
