extends CharacterBody2D

@export_range(1, 10) var health: int = 3

const GRAVITY = GLOBAL.GRAVITY

@onready var animation = $AnimatedSprite2D

func _ready():
	animation.play("idle")

func _process(_delta):
	velocity.y += GRAVITY

	if health <= 0:
		queue_free()

func damage():
	health -= 1
	print(health)
