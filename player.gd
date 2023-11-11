extends CharacterBody2D


@export var velocidad: float = 200.0
@export var salto: float = -200.0
@export var dobleSalto: float = -100.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hizo_doble_salto: bool = false
var animation_locked: bool = false
var direction : Vector2 = Vector2.ZERO
var was_in_air: bool = false


#signal fireball_shot(fireball_scene, location)
var fireball_scene = preload("res://fireball.tscn")
@onready var cetroPosition = $Marker2D

func _process(delta):
	if (Input.is_action_just_pressed("Disparo")):
		shoot()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		hizo_doble_salto = false
		if was_in_air == true:
			land()
		was_in_air = false

	# Handle Jump.
	if Input.is_action_just_pressed("Salto"):
		if is_on_floor():
			jump()
		elif not hizo_doble_salto:
			double_jump()
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("Mover_Izquierda", "Mover_Derecha", "mover_arriba", "mover_abajo")
	if direction.x !=0 && animated_sprite.animation != "jump_end" :
		velocity.x = direction.x * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)

	move_and_slide()
	update_animation()
	update_facing_direction()

func update_animation():
	if not animation_locked:
		if not is_on_floor():
			animated_sprite.play("jump_loop")
		else:
			if direction.x != 0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
		
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x<0:
		animated_sprite.flip_h = true
		
func jump():
	velocity.y = salto #salto normal
	animated_sprite.play("jump_start")
	animation_locked = true
	
func double_jump():
	velocity.y = dobleSalto
	animated_sprite.play("jump_double")
	animation_locked = true
	hizo_doble_salto = true
	
	
func land():
	animated_sprite.play("jump_end")
	animation_locked = true


func _on_animated_sprite_2d_animation_finished():
	
	if (["jump_end", "jump_start", "jump_double"].has(animated_sprite.animation)):
		animation_locked = false
		

func shoot():
	var fireball = fireball_scene.instantiate()
	fireball.position = cetroPosition.global_position
	fireball.set_direction(direction)
	
	get_parent().add_child(fireball)
	#fireball_shot.emit(fireball_scene, cetroPosition.global_position)
	#fireball.posi = cetroPosition.global_position
	#var fireball = fireball_scene.instantiate()
	#fireball.position = cetroPosition.global_position
	#fireball.velocity = direction*300
	#fireball.rotation = cetroPosition.global_rotation
	#get_parent().add_child(fireball)
