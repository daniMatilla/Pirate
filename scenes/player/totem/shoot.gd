extends Area2D

var direction: int
@onready var can_move: bool = true

func _ready():
	$AnimationPlayer.play("idle")

func _process(delta):
	if can_move:
		global_position.x += direction * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		body.apply_damage(1)
		$AnimationPlayer.play("destroy")
	elif !body.is_in_group("player"):
		$AnimationPlayer.play("destroy")

func _on_animation_player_animation_started(anim_name: StringName):
	match anim_name:
		"destroy":
			can_move = false

func _on_animation_player_animation_finished(anim_name: StringName):
	match anim_name:
		"destroy":
			queue_free()
