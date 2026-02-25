extends Node2D

@onready var interaction_area : InteractionArea = $Interaction
@onready var sprite = $Sprite2D
@export var associatedmanager : Node2D
@onready var getcamera = get_tree().get_first_node_in_group("Camera")
@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var ZoomTimer = $Timer
@onready var DeleteTimer = $DeleteTimer
@onready var C4Sprite = load("res://Sprites/etc/WoodstackC4.png")
@onready var Explosion = $AnimatedSprite2D
@onready var ExplosionSound = $AudioStreamPlayer
@onready var ExplosionTimer = $Explosion
@onready var queuefreetimer = $Timer2
@onready var camera = get_tree().get_first_node_in_group("Camera")
@onready var objective = get_tree().get_first_node_in_group("Objective")
@export var finishobjective : String
@export var islevel1 = false
var maxwave : int
var currentwave : int
var objectivestring = str("- Kill ", currentwave, "/", maxwave, " Zombies to pass!")
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	loadwaves()

func loadwaves():
	currentwave = 0
	maxwave = associatedmanager._Waves

func _on_interact():
	sprite.texture = C4Sprite
	if associatedmanager == null:
		pass
	else:
		associatedmanager.activated = true
	objective.ChangeObjective(associatedmanager.objectivestring)

func DestroyBarrier():
	getcamera.target = self 
	ExplosionTimer.start()
	ZoomTimer.start()
	DeleteTimer.start()

func _on_timer_timeout() -> void:
	objective.ChangeObjective(finishobjective)
	getcamera.target = Player
	getcamera.set_zoom(Vector2(1,1))
	queuefreetimer.start()
	
func _on_delete_timer_timeout() -> void:
	sprite.visible = false

func _on_explosion_timeout() -> void:
	objective.ChangeObjective(finishobjective)
	camera.ScreenShake(45,0.3)
	Explosion.visible = true
	Explosion.play()
	ExplosionSound.play()

func _on_timer_2_timeout() -> void:
	queue_free()

func changeobjective():
	objective.ChangeObjective(associatedmanager.objectivestring)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		DestroyBarrier()
