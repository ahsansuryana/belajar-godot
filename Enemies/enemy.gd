extends CharacterBody2D

@export var max_range = 104
@export var speed = 50
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"IdleState" : pass
		"ChaseState" : 
			var player = get_palyer()
			if player is Player:
				velocity = global_position.direction_to(player.global_position) * speed
				sprite_2d.scale.x =  sign(velocity.x)
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

func can_see_player() -> bool:
	if not is_player_in_range(): return false
	var player = get_palyer()
	ray_cast_2d.target_position = player.global_position - global_position
	ray_cast_2d.force_raycast_update()
	var has_los_to_player: = not ray_cast_2d.is_colliding()
	return has_los_to_player
