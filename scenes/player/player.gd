extends CharacterBody2D

@onready var sprite = $Sprite
@onready var jump_sound = $JumpSound
@onready var screen_size = get_viewport_rect().size

const SPEED = 100
const GRAVITY = 70 * 9.8
const JUMP = .32

func motion_ctrl(axis: Vector2):
	velocity.x = axis.x * SPEED if (axis != Vector2.ZERO) else 0.0
	pass

func animation_ctrl(axis: Vector2):
	if is_on_floor():
		if axis.x == 0:
			sprite.animation = "idle"
		else:
			sprite.animation = "run"
			sprite.flip_h = axis.x != 1
	else:
		if velocity.y < 0:
			sprite.animation = "jump"
		else:
			sprite.animation = "fall"
	pass

func _ready():
	sprite.animation = "idle"
	sprite.play()
	pass

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	var axis = GLOBAL.get_axis()
	
	motion_ctrl(axis)
	animation_ctrl(axis)
	
	move_and_slide()
	pass
	
func _input(event):
	var event_jump = event.is_action_pressed("ui_accept")
	
	if event_jump and is_on_floor():
		velocity.y -= GRAVITY * JUMP		
		jump_sound.play()
	pass
