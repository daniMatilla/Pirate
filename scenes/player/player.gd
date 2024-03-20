extends CharacterBody2D

@onready var sprite = $Sprite
@onready var jump_sound = $JumpSound
@onready var screen_size = get_viewport_rect().size

var axis: Vector2
var can_jump

const SPEED = 100
const GRAVITY = 70 * 9.8
const JUMP = .32

func motion_ctrl():
	if axis == Vector2.ZERO:
		velocity.x = 0
	else:
		velocity.x = axis.x * SPEED
	
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
	can_jump = is_on_floor()
	axis = GLOBAL.get_axis()	
	velocity.y += GRAVITY * delta
	
	motion_ctrl()
	animation_ctrl()
	
	move_and_slide()
	pass
	
func _input(event):
	var action_jump = event.is_action_pressed("ui_accept")
	
	if action_jump && can_jump:
		velocity.y -= GRAVITY * JUMP
		sprite.animation = "jump"
		jump_sound.play()
	pass
