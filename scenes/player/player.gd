extends CharacterBody2D

const SPEED = 100
const GRAVITY = 64 * 9.8
const JUMP_HEIGHT = .35
const CAST_WALL = 10
const BOUNDING_JUMP = (GRAVITY * JUMP_HEIGHT) / 2

@onready var sprite = $Sprite
@onready var jump_sound = $JumpSound
@onready var dust = $Dust
@onready var ray_cast = $RayCast
var is_jump: bool
var can_move: bool

func motion_ctrl(axis: Vector2):
	if can_move:
		if axis != Vector2.ZERO:
			velocity.x = axis.x * SPEED
		else:
			velocity.x = 0

func animation_ctrl(axis: Vector2):
	dust.emitting = false
	if is_on_floor():
		can_move = true
		if axis.x == 0:
			sprite.animation = "idle"
		else:
			dust.emitting = true
			sprite.animation = "run"
			if axis.x == 1:
				sprite.flip_h = false
				ray_cast.target_position.y = CAST_WALL
			else:
				sprite.flip_h = true
				ray_cast.target_position.y = -CAST_WALL
	else:
		if velocity.y < 0:
			sprite.animation = "jump"
		else:
			sprite.animation = "fall"

func wall_jump():
	var collider = ray_cast.get_collider()
	
	if collider.is_in_group("wall") and is_jump:
		jump_sound.play()
		velocity.y -= BOUNDING_JUMP
		if sprite.flip_h:
			velocity.x += BOUNDING_JUMP
			sprite.flip_h = false
		else:
			velocity.x -= BOUNDING_JUMP
			sprite.flip_h = true

func _ready():
	sprite.play()

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	var axis = GLOBAL.get_axis()
	
	motion_ctrl(axis)
	animation_ctrl(axis)
	
	move_and_slide()
	
func _input(event):
	is_jump = event.is_action_pressed("ui_accept")
	
	if is_on_floor() and is_jump:
		jump_sound.play()
		velocity.y -= GRAVITY * JUMP_HEIGHT
	elif ray_cast.is_colliding():
		can_move = false
		wall_jump()
