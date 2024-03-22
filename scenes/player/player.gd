extends CharacterBody2D

const SPEED = 100
const JUMP_HEIGHT = .35
const GRAVITY = GLOBAL.GRAVITY
const JUMP_FORCE = GRAVITY * JUMP_HEIGHT
const JUMP_BOUNDING = JUMP_FORCE / 2
const GRAP_FORCE = GRAVITY / 25

@onready var sprite = $Sprite
@onready var animation_tree = $AnimationTree
@onready var jump_sound = $Sounds/Jump
@onready var attack_sound = $Sounds/Attack
@onready var dust = $Dust
@onready var ray_wall = $RayCasts/RayWall
@onready var ray_eneny = $RayCasts/RayEnemy
@onready var ray_casts = $RayCasts

var playback: AnimationNodeStateMachinePlayback
var can_move: bool
var axis: Vector2

var pressed_jump: bool
var pressed_attack: bool

func _ready():
	playback = animation_tree.get("parameters/playback")
	playback.start("idle")
	animation_tree.active = true

func _process(delta):
	velocity.y += GRAVITY * delta
	axis = GLOBAL.get_axis()

	motion_ctrl()
	animation_ctrl()

func attack_ctrl():
	var enemy = ray_eneny.get_collider()
	if ray_eneny.is_colliding():
		if enemy.is_in_group("enemy"):
			enemy.damage()

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
		ray_casts.scale.x = -1 if sprite.flip_h else 1
	
	if pressed_attack:
		match playback.get_current_node():
			"idle", "run":
				playback.travel("attack_1")
			"attack_1":
				playback.travel("attack_2")
			"attack_2":
				playback.travel("attack_3")

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
			wall_jump()

	move_and_slide()

func wall_jump():
	var wall = ray_wall.get_collider()

	if wall.is_in_group("wall"):
		can_move = false
		velocity.y = GRAP_FORCE
		if pressed_jump:
			jump_sound.play()
			velocity.y = -JUMP_FORCE

			if sprite.flip_h:
				velocity.x += JUMP_BOUNDING
				sprite.flip_h = false
			else:
				velocity.x -= JUMP_BOUNDING
				sprite.flip_h = true

	ray_wall.enabled = false

func _input(event):
	pressed_jump = event.is_action_pressed("ui_accept")
	pressed_attack = event.is_action_pressed("attack")
