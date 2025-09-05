extends CharacterBody3D

var speed : int = 12
var overspeed : float = 0.0
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
	%camera.rotation.z = lerp(%camera.rotation.z, -input.x * cam_tilt_amount, delta * 7)
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)

	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_force
		if input.x and input.y:
			movement_dir += Vector3(movement_dir.x + jump_boost, 0, movement_dir.z + jump_boost)
			overspeed = velocity.length()
			$HUD/debug/VBoxContainer/MarginContainer/Label.text = str(overspeed)

	# inertia and in air restricted move
	if is_on_floor():
		if movement_dir:
			if velocity.length() > speed + 1:
				velocity.x = movement_dir.x * overspeed
				velocity.z = movement_dir.z * overspeed
				overspeed -= 0.1
				$HUD/debug/VBoxContainer/MarginContainer/Label.text = str(overspeed)
			else:
				velocity.x = movement_dir.x * speed
				velocity.z = movement_dir.z * speed
		else:
			velocity.x = lerp(velocity.x, movement_dir.x * speed, delta * floor_friction)
			velocity.z = lerp(velocity.z, movement_dir.z * speed, delta * floor_friction)
	else:
		velocity.x = lerp(velocity.x, movement_dir.x * air_speed, delta * air_friction)
		velocity.z = lerp(velocity.z, movement_dir.z * air_speed, delta * air_friction)

	velocity = clamp(velocity, Vector3(-40, -40, -40), Vector3(40, 40, 40))
	move_and_slide()
