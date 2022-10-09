extends CharacterBody2D

@export var move_speed: float = 12
@export var min_idle_time: float = 4
@export var max_idle_time: float = 6
@export var min_walk_time: float = 1
@export var max_walk_time: float = 2

enum State { IDLE, WALKING }
var current_state = State.IDLE

var rng = RandomNumberGenerator.new()

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2d
@onready var timer = $Timer

func _ready():
	rng.randomize()
	timer.start(gen_idle_time())

func _physics_process(_delta):
	move_and_slide()

func swap_state():
	if (current_state == State.IDLE):
		current_state = State.WALKING
		state_machine.travel("Walk")
		randomize_velocity(move_speed)
		timer.start(gen_walk_time())
	else:
		current_state = State.IDLE
		state_machine.travel("Idle")
		randomize_velocity(0)
		timer.start(gen_idle_time())

func randomize_velocity(speed):
	var random_x = rng.randf_range(-1, 1)
	var random_y = rng.randf_range(-1, 1)
	velocity = Vector2(random_x, random_y).normalized() * speed 
	if (velocity.x < 0):
		sprite.flip_h = true
	elif (velocity.x > 0):
		sprite.flip_h = false

func gen_idle_time():
	return rng.randf_range(min_idle_time, max_idle_time)

func gen_walk_time():
	return rng.randf_range(min_walk_time, max_walk_time)

func _on_timer_timeout():
	swap_state()
