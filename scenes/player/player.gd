extends CharacterBody2D

const SPEED = 100
const JUMP_HEIGHT = .35
const GRAVITY = GLOBAL.GRAVITY
const JUMP_FORCE = GRAVITY * JUMP_HEIGHT
const JUMP_BOUNDING = JUMP_FORCE / 2
const CAST_WALL = 10
const CAST_ENEMY = 22

@onready var sprite = $Sprite
@onready var animation_tree = $AnimationTree
@onready var jump_sound = $Sounds/Jump
@onready var hit_sound = $Sounds/Hit
@onready var dust = $Dust
@onready var ray_wall = $RayWall
@onready var ray_eneny = $RayEnemy

var playback: AnimationNodeStateMachinePlayback
var can_move: bool
var axis: Vector2

var pressed_jump: bool

func _ready():
	playback = animation_tree.get("parameters/playback")
	playback.start("idle")
	animation_tree.active = true

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	axis = GLOBAL.get_axis()
 
	motion_ctrl()
	direction_ctrl()
	animation_ctrl()
	attack_ctrl()

func kill_enemy():
	var collider = ray_eneny.get_collider()

	if collider != null and collider.is_in_group("enemy"):
		collider.queue_free()

func attack_ctrl():
	if is_on_floor() and Input.is_action_pressed("attack"):
		match playback.get_current_node():
			"idle", "run":
				playback.travel("attack_1")
				hit_sound.play()
			"attack_1":
				playback.travel("attack_2")
				hit_sound.play()
			"attack_2":
				playback.travel("attack_3")
				hit_sound.play()

	ray_eneny.enabled = playback.get_current_node() in ["attack_1", "attack_2", "attack_3"]
	if ray_eneny.is_colliding():
		kill_enemy()

func animation_ctrl():
	dust.emitting = false
	if is_on_floor():
		if axis.x == 0:
			playback.travel("idle")
		else:
			dust.emitting = true
			playback.travel("run")
			sprite.flip_h = axis.x != 1
	else:
		playback.travel("jump" if velocity.y < 0 else "fall")

func direction_ctrl():
	match sprite.flip_h:
		false:
			ray_wall.target_position.x = CAST_WALL
			ray_eneny.target_position.x = CAST_ENEMY
		true:
			ray_wall.target_position.x = -CAST_WALL
			ray_eneny.target_position.x = -CAST_ENEMY

func motion_ctrl():
	if can_move:
		velocity.x = axis.x * SPEED

	if is_on_floor():
		can_move = true
		if pressed_jump:
			jump_sound.play()
			velocity.y -= JUMP_FORCE
	else:
		ray_wall.enabled = velocity.y >= 0
		if ray_wall.is_colliding():
			can_move = false
			wall_jump()

	move_and_slide()

func wall_jump():
	var collider = ray_wall.get_collider()

	if collider.is_in_group("wall") and pressed_jump:
		jump_sound.play()
		velocity.y -= JUMP_FORCE
		if sprite.flip_h:
			velocity.x += JUMP_BOUNDING
			sprite.flip_h = false
		else:
			velocity.x -= JUMP_BOUNDING
			sprite.flip_h = true
	
	ray_wall.enabled = false

func _input(event):
	pressed_jump = event.is_action_pressed("ui_accept")