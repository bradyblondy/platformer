extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = -180
export (int) var gravity = 400
export (int) var slide_speed = 400


var velocity = Vector2.ZERO 

export (float) var friction = 10
export (float) var acceleration = 25 

enum state {IDLE, RUNNING, PUSHING, ROLLING, JUMP, JUMPSTART, FALL, ATTACK}

onready var player_state = state.IDLE 


func _ready():
	$AnimationPlayer.play("idle")
	pass

func update_animation(anim):
	if velocity.x < 0:
		$Sprite.flip_h = true
	if velocity.x > 0:
		$Sprite.flip_h = false
	match(anim):
		state.FALL:
			$AnimationPlayer.play("fall")
		state.ATTACK:
			$AnimationPlayer.play("attack")
		state.IDLE:
			$AnimationPlayer.play("idle")
		state.JUMP:
			$AnimationPlayer.play("jump")
		state.PUSHING:
			$AnimationPlayer.play("pushing")
		state.RUNNING:
			$AnimationPlayer.play("running")
		
	pass
	
func handle_state(player_state):
	match(player_state):
		state.JUMPSTART:
			velocity.y = jump_speed
	pass

func get_input():
	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	if dir != 0:
		velocity.x = move_toward(velocity.x, dir*speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

func _physics_process(delta):
	get_input()
	print(is_on_floor())
	if velocity == Vector2.ZERO:
		player_state = state.IDLE
	if Input.is_action_just_pressed("jump") and is_on_floor():
		player_state = state.JUMPSTART 
	elif velocity.x != 0:
		player_state = state.RUNNING
	
	if not is_on_floor():
		if velocity.y < 0:
			player_state = state.JUMP
		if velocity.y > 0: 
			player_state = state.FALL
			
	handle_state(player_state)
	update_animation(player_state)
	#set gravity
	velocity.y += gravity * delta 
	velocity = move_and_slide(velocity, Vector2.UP)
	 
	
	