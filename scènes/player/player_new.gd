extends CharacterBody3D

var speed : int = 12
var overspeed : float = 0.0
var max_overspeed : float = 8.0
var overspeed_gain : float = 0.15
var overspeed_decay : float = 0.20
var air_speed : int = 16
var jump_force : int = 7
var jump_boost : float = 7.5
var jump_boost_percentage : float = 10.0
var gravity : int = 18
var air_friction : float = 4.0
var floor_friction : float = 6.3
var mouse_sensitivity : float = 0.002
var cam_tilt_amount : float = 0.09

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		%head.rotate_x(-event.relative.y * mouse_sensitivity)
		%head.rotation.x = clampf(%head.rotation.x, -deg_to_rad(90.0), deg_to_rad(90.0))

func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "backward")
	%head.rotation.z = lerp(%head.rotation.z, -input.x * cam_tilt_amount, delta * 7)
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)

	# Détection du mouvement diagonal
	var is_diagonal = abs(input.x) > 0.1 and abs(input.y) > 0.1

	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_force

	# Gestion de l'overspeed pour boost en diagonale
	if is_on_floor():
		if is_diagonal:
			overspeed += overspeed_gain
		else:
			overspeed -= overspeed_decay
		overspeed = clamp(overspeed, 0.0, max_overspeed)
		$HUD/debug/VBoxContainer/MarginContainer/Label.text = str(overspeed)

		var local_speed = speed + overspeed
		if movement_dir.length() > 0:
			velocity.x = movement_dir.x * local_speed
			velocity.z = movement_dir.z * local_speed
		else:
			velocity.x = lerp(velocity.x, 0.0, delta * floor_friction)
			velocity.z = lerp(velocity.z, 0.0, delta * floor_friction)
		%camera.bob_frequency = velocity.length() / 1.36
	else:
		velocity.x = lerp(velocity.x, movement_dir.x * air_speed, delta * air_friction)
		velocity.z = lerp(velocity.z, movement_dir.z * air_speed, delta * air_friction)

	velocity = clamp(velocity, Vector3(-40, -40, -40), Vector3(40, 40, 40))
	if input:
		if is_on_floor(): %camera.is_moving = true
		else: %camera.is_moving = false
	else: %camera.is_moving = false
	move_and_slide()
