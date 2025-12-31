class_name Player extends CharacterBody2D

const SPEED = 100
const ROLL_SPEED = 125
var input_vector = Vector2.ZERO
var last_input_vector = Vector2.ZERO
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"MoveState" : 
			input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
			#print(input_vector.length() > 0.0)
			if input_vector != Vector2.ZERO:
				last_input_vector = input_vector
				update_blend_pos(input_vector)
			if Input.is_action_just_pressed("attack"):
				playback.travel("AttackState")
			if Input.is_action_just_pressed("roll"):
				playback.travel("RollState")
			velocity = input_vector * SPEED
			move_and_slide()
		"AttackState":
			pass
		"RollState":
			velocity = last_input_vector.normalized() * ROLL_SPEED
			move_and_slide()
	

func update_blend_pos(vector_input : Vector2) -> void:
		vector_input = Vector2(vector_input.x, -vector_input.y)
		animation_tree.set("parameters/StateMachine/MoveState/run/blend_position", vector_input)
		animation_tree.set("parameters/StateMachine/MoveState/stand/blend_position", vector_input)
		animation_tree.set("parameters/StateMachine/AttackState/Attack/blend_position",vector_input)
		animation_tree.set("parameters/StateMachine/RollState/BlendSpace2D/blend_position",vector_input)
	
