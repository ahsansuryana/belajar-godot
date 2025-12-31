extends CharacterBody2D

@export var max_range = 104
@export var speed = 50

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"IdleState" : pass
		"ChaseState" : 
			var player = get_palyer()
			if player is Player:
				velocity = global_position.direction_to(player.global_position) * 75
			else :
				velocity = Vector2.ZERO
			move_and_slide()

func get_palyer() -> Player:
	return get_tree().get_first_node_in_group("player")

func is_player_in_range() -> bool:
	var result = false
	var player = get_palyer()
	if player is Player:
		var player_distance = global_position.distance_to(player.global_position)
		if player_distance < max_range:
			result = true
	return result
