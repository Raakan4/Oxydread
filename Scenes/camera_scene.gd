extends Camera2D
var isfocusedonplayer = true
@export var target : Node2D
@onready var ZoomTimer = $ZoomTimer
var StaggerZoomTime = 0.7
var StaggerXoffset = 10

var shake_intensity : float = 0.0
var active_shake_time : float = 0.0
var shake_decay : float = 5.0
var shake_time : float = 0.0
var shake_time_speed : float = 20.0
var noise = FastNoiseLite.new()
@onready var player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	if target != null:
		global_position = target.global_position
	else:
		return

func _physics_process(delta: float) -> void:
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		offset = Vector2(
			noise.get_noise_2d(shake_time, 0) * shake_intensity,
			noise.get_noise_2d(0, shake_time) * shake_intensity
		)
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5 * delta)

func ZoomIn(_target):
	target = _target
	ZoomTimer.wait_time = StaggerZoomTime
	set_zoom(Vector2(3,3))
	offset.x += StaggerXoffset
	ZoomTimer.start()
	return
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "zoom", Vector2(0.5,0.5), 0.2).set_trans(tween.EASE_IN)

func ScreenShake(intensity: int,duration: float):
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	shake_intensity = intensity
	active_shake_time = duration
	shake_time = 0.0

func _on_zoom_timer_timeout() -> void:
	set_zoom(Vector2(1,1))
	offset.x -= StaggerXoffset
	target = player
	
