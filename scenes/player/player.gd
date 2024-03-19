extends CharacterBody2D

@onready var sprite = $Sprite
@onready var motion = Vector2.ZERO
@onready var screen_size = get_viewport_rect().size
var axis: Vector2

const SPEED = 100
const GRAVITY = 16
const JUMP = 64

func motion_ctrl():
	motion.y += GRAVITY
	if axis == Vector2.ZERO:
		motion = Vector2.ZERO
	else:
		motion = axis * SPEED
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	pass

func animation_ctrl():
	if axis.x == 1:
		sprite.animation = "run"
		sprite.flip_h = false
	elif axis.x == - 1:
		sprite.animation = "run"
		sprite.flip_h = true
	else:
		sprite.animation = "idle"
	pass

func _ready():
	sprite.animation = "idle"
	sprite.play()
	pass

func _physics_process(delta):
	axis = GLOBAL.get_axis()
	motion_ctrl()
	animation_ctrl()
	move_and_collide(motion * delta)
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		sprite.animation = "jump"
	pass
