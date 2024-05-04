extends CharacterBody3D;
class_name Player;

@onready var head := $Head;
@onready var camera := $Head/Camera;
@onready var debug_arrow_velocity := $ArrowVelocityPivot;
@onready var weapon_attach := $Head/Camera/WeaponAttach;
@onready var weapon_viewmodel_node := $Head/Camera/WeaponAttach/ViewmodelControl/Weapon;

const BASE_SPEED: float = 6.0;
const JUMP_VELOCITY: float = 4.5;

const MAX_SPEED: float = 20.0;
const MAX_ACCEL: float = 4 * MAX_SPEED;

const ACCEL_GROUND: float = 0.5;
const ACCEL_AIR: float = 0.2;
const DECCEL_GROUND: float = 0.3;
const DECCEL_AIR: float = 0.2;
var GRAVITY_BASE: float = ProjectSettings.get_setting("physics/3d/default_gravity");

var gravity: float = GRAVITY_BASE;
var speed: float = BASE_SPEED;

var accel: float = 0.0;
var deccel: float = 0.0;

var is_falling: bool = false;
var is_jumping: bool = false;
var is_crouched: bool = false;

var jump_force: float = JUMP_VELOCITY;
var jump_trigger: bool = false;
var jump_buffer_max = 7.0;
var jump_buffer = 0.0;

var camera_tilt: float;

var mesh_instance;
var im_mesh;
var material;

var input_dir = 0;

func _ready():
	Engine.time_scale = 1.0;

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * .0025);
			camera.rotate_x(-event.relative.y * .0025);
			

func _process(delta):
	var vec = Vector2(velocity.z, velocity.x);
	var l = vec.length();
	var r = vec.angle_to_point(Vector2(0, 1));
	
	debug_arrow_velocity.scale = Vector3(l, 1, l);
	debug_arrow_velocity.rotation = Vector3(0, r, 0);
	
	_camera_tilt(input_dir);
	
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90));
	camera.rotation.y = 0.0;
	#Draw.line(Vector3(position.x, 0, position.z), Vector3(position.x + velocity.x, 0, position.z + velocity.z), Color.BLACK, 1);

func _physics_process(delta: float) -> void:
	
	input_dir = Input.get_vector("left", "right", "forward", "back");
	var key_crouch = Input.is_action_pressed("crouch");
	
	is_crouched = true if key_crouch else false;
	
	if is_crouched:
		$Collision.disabled = true;
		$CollisionCrouch.disabled = false;
		head.position.y = lerp(head.position.y, -0.1, 0.3);
		weapon_viewmodel_node.position.y = lerp(weapon_viewmodel_node.position.y, 0.05, 0.1);
	else:
		if !test_move(global_transform, Vector3(0, .2, 0)):
			$Collision.disabled = false;
			$CollisionCrouch.disabled = true;
			head.position.y = lerp(head.position.y, 0.6, 0.3);
			weapon_viewmodel_node.position.y = lerp(weapon_viewmodel_node.position.y, 0.0, 0.1);
		
	if velocity.y > 0:
		is_falling = true;
	else:
		is_falling = false;
	
	if !is_falling:
		if velocity.y < -1:
			gravity = lerp(gravity, GRAVITY_BASE * 2, .25);
		else:
			gravity = GRAVITY_BASE;
	else:
		gravity = GRAVITY_BASE * 1.1;
	
	if is_on_floor():
		accel = ACCEL_GROUND;
		deccel = DECCEL_GROUND;
		is_jumping = false;
		is_falling = false;
		jump_trigger = false;
	else:
		accel = ACCEL_AIR;
		deccel = DECCEL_AIR;
		velocity.y -= gravity * delta;
	
	if !is_jumping:
		jump_force = JUMP_VELOCITY * ((abs(velocity.x) * .0015) + 1);
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = jump_buffer_max;
	
	if jump_buffer > 0:
		jump_buffer -= 1;
		
		if !jump_trigger && is_on_floor():
			velocity.y = jump_force;
			jump_trigger = true;
	
	
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();

	if direction:
		var vel = accelerate(velocity, direction, delta);
		velocity.x = lerp(vel[0], direction.x * speed, accel);
		velocity.z = lerp(vel[2], direction.z * speed, accel);
	else:
		velocity.x = lerp(velocity.x, 0.0, deccel);
		velocity.z = lerp(velocity.z, 0.0, deccel);

	move_and_slide();
	
	

func _camera_tilt(input_dir):
	
	var value: float = input_dir[0] / MAX_SPEED;
	camera_tilt = lerp(camera_tilt, value, 0.1);
	if abs(camera_tilt) < 0.001:
		camera_tilt = 0;
	head.rotation.z = camera_tilt;
	

func accelerate(velocity: Vector3, move_direction: Vector3, delta: float) -> Vector3:
	
	velocity = lerp(velocity, Vector3(0.0, 0.0, 0.0), delta);
	
	var current_speed = velocity.dot(move_direction);
	var add_speed = clamp(MAX_SPEED - current_speed, 0.0, MAX_ACCEL * delta);
	
	return velocity + add_speed * move_direction;
