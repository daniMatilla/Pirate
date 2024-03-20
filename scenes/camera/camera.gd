extends Camera2D

@onready var player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(_delta):
    global_position.x = player.global_position.x