extends KinematicBody2D;

signal started_moving;
signal finished;

const GRAVITY = 16.8;
const MOVE_SPEED = 31.0;
const JUMP_HEIGHT = 230.0;
const JUMP_CUTOFF = 0.68;
const WALL_JUMP_VEL = Vector2(140.0, 300.0);
const FRICTION = 0.76;
const AIR_FRICTION = 0.80;
const COYOTE_TIME = 0.1;
const FOOTSTEP_TIME = 0.25;
var footstep_timer = 0.0;

var input = Vector2(0.0, 0.0);
var facing_dir = 1.0;
var velocity = Vector2(0.0, 0.0);
var coyote_timer = 0.0;
var jump_timer = 0.0;
var left_check = false;
var right_check = false;
var on_wall = false;
var has_hit_ground_after_wall_jump = true;

var current_checkpoint = "Checkpoint1";

var started_moving = false;


func _ready():
	position = get_node("../Checkpoints/Checkpoint1").position;

func _physics_process(delta):
	on_wall = left_check || right_check;
	
	_handle_horizontal_movement(delta);
	_handle_ground_detection(delta);
	_handle_jump(delta);
	
	_perform_friction();
	_perform_gravity();
	
	velocity = move_and_slide(velocity, Vector2.UP);
	
	if position.y >= 200.0 || Input.is_action_just_pressed("respawn"):
		_respawn();
	
	_perform_animations();
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene();
	
	if !started_moving:
		if Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_up"):
			started_moving = true;
			emit_signal("started_moving");
	
	if Input.is_action_just_pressed("back") && get_tree().get_current_scene().name.find("Level") != -1:
		get_tree().change_scene("res://Scenes/Levels/Hub.tscn");


func _handle_horizontal_movement(delta):
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	if input.x != 0.0 && is_on_floor():
		facing_dir = input.x;
		footstep_timer -= delta;
		if footstep_timer <= 0.0:
			SoundPlayer.footstep();
			footstep_timer = FOOTSTEP_TIME;
	else:
		footstep_timer = 0.0;
	if on_wall:
		if left_check:
			facing_dir = -1.0;
		elif right_check:
			facing_dir = 1.0;
	
	if (is_on_floor() || !on_wall) && has_hit_ground_after_wall_jump:
		velocity.x += input.x * MOVE_SPEED;

func _handle_ground_detection(delta):
	coyote_timer -= delta;
	if is_on_floor():
		coyote_timer = COYOTE_TIME;
		has_hit_ground_after_wall_jump = true;
	elif on_wall:
		has_hit_ground_after_wall_jump = false;

func _handle_jump(delta):
	jump_timer -= delta;
	if Input.is_action_just_pressed("ui_up"):
		if left_check:
			velocity = Vector2(WALL_JUMP_VEL.x, -WALL_JUMP_VEL.y);
			facing_dir = 1.0;
			SoundPlayer.jump();
		elif right_check:
			velocity = Vector2(-WALL_JUMP_VEL.x, -WALL_JUMP_VEL.y);
			facing_dir = -1.0;
			SoundPlayer.jump();
		else:
			jump_timer = COYOTE_TIME;
	
	if jump_timer > 0.0 && coyote_timer > 0.0:
		jump_timer = 0.0;
		coyote_timer = 0.0;
		
		velocity.y = -JUMP_HEIGHT;
		SoundPlayer.jump();
	
	if Input.is_action_just_released("ui_up") && velocity.y < 0.0:
		velocity.y *= JUMP_CUTOFF;


func _perform_friction():
	if has_hit_ground_after_wall_jump:
		if is_on_floor():
			velocity.x *= FRICTION;
		else:
			velocity.x *= AIR_FRICTION;
	if on_wall:
		velocity.y *= FRICTION;

func _perform_gravity():
	velocity.y += GRAVITY;

func _perform_animations():
	get_node("Sprite").rotation_degrees = lerp(get_node("Sprite").rotation_degrees, input.x * 8.0, 0.3);
	get_node("Camera").offset.x = lerp(get_node("Camera").offset.x, input.x * 16.0, 0.1);
	
	get_node("Sprite").set_flip_h(facing_dir == -1.0);
	if is_on_floor():
		if input.x == 0.0:
			get_node("Sprite").animation = "Idle";
		else:
			get_node("Sprite").animation = "Run";
	elif on_wall:
		get_node("Sprite").animation = "WallSlide";
	else:
		if velocity.y < 0.0:
			get_node("Sprite").animation = "Jump";
		else:
			get_node("Sprite").animation = "Fall";


func _on_left_check_body_entered(_body):
	left_check = true;

func _on_left_check_body_exited(_body):
	left_check = false;

func _on_right_check_body_entered(_body):
	right_check = true;

func _on_right_check_body_exited(_body):
	right_check = false;


func _respawn():
	position = get_node("../Checkpoints/" + current_checkpoint).position;
	velocity = Vector2(0.0, 0.0);
	SoundPlayer.lose();


func _on_trigger_area_entered(area):
	if area.name.find("Checkpoint") != -1:
		_handle_checkpoint(area);
	if area.name == "Flag":
		SoundPlayer.flag();
		emit_signal("finished");

func _on_trigger_body_entered(body):
	if body.name.find("Spikes") != -1:
		_respawn();


func _handle_checkpoint(checkpoint):
	if current_checkpoint != checkpoint.name:
		SoundPlayer.checkpoint();
	
	current_checkpoint = checkpoint.name;
	
	for other_checkpoint in get_node("../Checkpoints").get_children():
		get_node(str(other_checkpoint.get_path()) + "/Sprite").animation = "Off";
	
	get_node(str(checkpoint.get_path()) + "/Sprite").animation = "On";
