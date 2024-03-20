extends Node

@onready var score: int
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func get_axis() -> Vector2:
	var axis: Vector2 = Vector2.ZERO
	
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	# axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()

func random(min_value, max_value):
	rng.randomize()
	return rng.randf_range(min_value, max_value)
