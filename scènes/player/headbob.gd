extends Camera3D

@export var bob_amplitude : float = .8    # amplitude en degrés
@export var bob_frequency : float = 8.0    # fréquence du headbob
var bob_time : float = 0.0
var is_moving: bool = false

func _physics_process(delta):
	if is_moving:
		bob_time += delta * bob_frequency
	else:
		bob_time = 0.0

	# Calcul de la rotation Z pour le bobbing
	var roll_deg = 0.0
	if is_moving:
		roll_deg = sin(bob_time) * bob_amplitude
	else: roll_deg = 0.0
	rotation_degrees.z = roll_deg
