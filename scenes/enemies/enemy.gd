extends CharacterBody2D

@export_range(1, 10) var health: int = 3

const GRAVITY = GLOBAL.GRAVITY

@onready var animation = $AnimatedSprite2D

func _ready():
	animation.play("idle")

func _process(delta):
	velocity.y += GRAVITY * delta
	move_and_slide()

	if health <= 0:
		queue_free()

func apply_damage(damage: int):
	health -= damage
	print("Enemy health: ", health)
