extends CharacterBody2D

const GRAVITY = GLOBAL.GRAVITY
@onready var animation_player = $AnimationPlayer

func _ready():
    animation_player.play("idle")
    
func _physics_process(delta):
    velocity.y += GRAVITY * delta

    move_and_slide()
