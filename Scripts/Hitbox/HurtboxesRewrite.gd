class_name Hurtbox extends Area2D

@export var isownedbyenemy : int
#var Hurtboxowner = get_tree()
@export var HurtboxOwner : CharacterBody2D
signal OuterTranisititon(Subject, State)
@onready var camera = get_tree().get_first_node_in_group("Camera")
func _ready() -> void:
	monitoring = false
	set_collision_layer_value(1, false )
	set_collision_mask_value(1, false )
	match isownedbyenemy:
		1:
			set_collision_layer_value(5, true )
		0: 
			set_collision_layer_value(4, true )

func receive_hit(damage: int, target) -> void:
	if isownedbyenemy == 0:
		if HurtboxOwner.is_staggered == false:
			HurtboxOwner.TakeDamage(damage)
			camera.ScreenShake(20,0.1)
			if HurtboxOwner.has_node("StateMachine"):
				var StateMachine = $"../StateMachine"
				StateMachine.on_child_transition(StateMachine.current_state,"MeleeKnockback")
			else:
				return
		if HurtboxOwner.is_staggered == true:
			var player = get_tree().get_first_node_in_group("Player")
			camera.ScreenShake(150,0.3)
			player.Heal(randi_range(5,10))
			HurtboxOwner.Staggerkill()
			HurtboxOwner.die()
		else:
			return
	if isownedbyenemy == 1:
		var players = get_tree().get_first_node_in_group("Player")
		players.TakeDamage(damage)
