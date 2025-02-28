extends KinematicBody2D

onready var _animated_sprite = $AnimatedSprite
onready var GAME_OVER = preload("res://src/scenes/GameOver.tscn")

var isDead = false
export var isQuiet = false
var velocity: Vector2 = Vector2(0.0,0.0)
var coins = 0
var run_velocity = 200.0
export(float) var flip = 1.0

export(float) var time_to_peak = 0.6 # seconds
export(float) var jump_height = 80.0 # pixels

onready var gravity = flip * (2.0*jump_height / pow(time_to_peak, 2.0))
onready var jump_speed = -gravity * time_to_peak 
onready var vectorFloor = Vector2.DOWN * Vector2(1.0, flip)
onready var vectorJump = Vector2.UP * Vector2(1.0, flip)

var can_double_jump = false  # Unlocks after collecting banana
var has_double_jumped = false  # Tracks if double jump is used

func _ready():
	pass

func _process(delta):
	if isDead:
		return
	if isQuiet:
		return
	
	if Input.is_action_just_pressed("ui_select"):
		if is_on_floor():
			velocity.y = jump_speed
			has_double_jumped = false  # Reset double jump
			$SoundJump.play()
		elif can_double_jump and not has_double_jumped:
			velocity.y = jump_speed  # Perform double jump
			has_double_jumped = true
			$SoundJump.play()
	
	if Input.is_action_pressed("ui_right"):
		_animated_sprite.animation = "run"
		_animated_sprite.flip_h = false
		velocity.x = run_velocity
	elif Input.is_action_pressed("ui_left"):
		_animated_sprite.animation = "run"
		_animated_sprite.flip_h = true
		velocity.x = -run_velocity
	else:
		_animated_sprite.animation = "idle"
		velocity.x = 0.0

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, vectorFloor, vectorJump)

func enable_double_jump():
	can_double_jump = true

func add_coin():
	coins += 1
	print("Coins:", coins)

func die():
	$SoundDead.play()
	isDead = true
	$AnimationPlayer.play("die")
	run_velocity = 0
	jump_speed = 0
	yield(get_node("AnimationPlayer"), "animation_finished")
	var gameOver = GAME_OVER.instance()
	get_parent().add_child(gameOver)
