extends Area2D

@export var Shoot: PackedScene

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]
@onready var player_sprite: Sprite2D = player.get_node("Sprite")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite
@onready var shoot_spawn: Marker2D = $ShootSpawn

var motion: float

func _ready():
	sprite.play("idle")

func _process(_delta):
	motion_ctrl()
	tween_ctrl()

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot_ctrl()
	else:
		sprite.play("idle")

func motion_ctrl():
	if player_sprite.flip_h:
		scale.x = -1
		motion = player.global_position.x + 22
	else:
		scale.x = 1
		motion = player.global_position.x - 22

func tween_ctrl():
	var tween = get_tree().create_tween()
	tween.tween_property(
		self,
		"global_position",
		Vector2(motion, player.global_position.y - 22),
		.2
	).set_trans(tween.TRANS_SINE).set_ease(tween.EASE_OUT)
	tween.play()

func shoot_ctrl():
	var shoot = Shoot.instantiate() as Area2D
	shoot.global_position = shoot_spawn.global_position

	sprite.play("attack")
	if player_sprite.flip_h:
		shoot.scale.x = -1
		shoot.direction = -224
	else:
		shoot.scale.x = 1
		shoot.direction = 224
	
	get_tree().call_group("level", "add_child", shoot)
