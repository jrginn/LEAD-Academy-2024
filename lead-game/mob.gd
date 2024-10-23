extends CharacterBody2D

var speed = 200

var x_velocity_sign = 1
var y_velocity_sign = 1

enum States {IDLE, RUN}

func _ready():
	$MovementTimer.start()

func _physics_process(delta):
	velocity.x = x_velocity_sign * speed
	velocity.y = y_velocity_sign * speed
	move_and_slide()

func _on_movement_timer_timeout() -> void:
	if randi() % 2:
		x_velocity_sign = 1
	else:
		x_velocity_sign = -1
	
	if randi() % 2:
		y_velocity_sign = 1
	else:
		y_velocity_sign = -1
