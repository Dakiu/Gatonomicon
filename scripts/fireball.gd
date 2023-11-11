extends Area2D

@export var speed = 300
var direction : Vector2 = Vector2.ZERO
var velocity = Vector2()

func set_direction(dir):
	direction = dir

func _physics_process(delta):
	velocity = direction*300*delta
	translate(velocity)
	#$RigidBody2D.velocity.x = direction.x *300*delta
	#global_position.x += speed *delta
