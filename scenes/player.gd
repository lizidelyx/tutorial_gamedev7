extends CharacterBody3D

@export var speed: float = 10.0
@export var crouch_speed: float = 5.0  # Kecepatan saat jongkok
@export var sprint_speed: float = 15.0  # Kecepatan saat sprint
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3
@export var crouch_height: float = -0.5  # Penyesuaian ketinggian saat jongkok

@onready var camera: Camera3D = $Head/Camera3D
var camera_x_rotation: float = 0.0

@onready var head: Node3D = $Head
var is_crouching: bool = false
var is_sprinting: bool = false
var default_camera_position: Vector3
var current_speed: float

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	default_camera_position = camera.position
	current_speed = speed

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Toggle crouch
	if Input.is_action_pressed("crouch"):
		if not is_crouching:
			camera.position.y += crouch_height
			is_crouching = true
			current_speed = crouch_speed
	elif Input.is_action_just_released("crouch"):
		camera.position = default_camera_position
		is_crouching = false
		current_speed = speed

	# Sprinting
	if Input.is_action_pressed("sprint") and not is_crouching:
		is_sprinting = true
		current_speed = sprint_speed
	elif Input.is_action_just_released("sprint"):
		is_sprinting = false
		current_speed = speed

func _physics_process(delta):
	var movement_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	move_and_slide()
