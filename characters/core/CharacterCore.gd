# Componente Core di tutti i Personaggi, Protagonista e NPC da Estendere per creare altre istanze
# di personaggi non giocanti.

extends CharacterBody2D

# Movement Speed di Default di tutti 
@export var movement_speed := 150.0

# Boolean che identifica se il personaggio è quello principale
@export var is_player := true

# TODO: Da spostare su NPC che estende CharacterCore
# Boolean che dichiara 
@export var is_interactive := false

# ON READY quando il componente è pronto ( a load finito ).
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

#TODO: Da inizializzare solo per NPC?
@onready var move_timer: Timer = $Timer

# Funzione che setta i valori iniziali di un Character
func _ready() -> void:
	navigation_agent.path_desired_distance = 2.0
	navigation_agent.target_desired_distance = 2.0
	navigation_agent.debug_enabled = true
	
	if not is_player:
		start_random_movement()

# Setta la posizione del Character
func set_target(pos: Vector2) -> void:
	navigation_agent.target_position = pos

func _unhandled_input(event: InputEvent) -> void:
	if not is_player:
		return

	if event.is_action_pressed("click"):
		set_target(get_global_mouse_position())

# Controller del movimento del Character
func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		sprite.stop()
		return

	var current_pos := global_position
	var next_pos := navigation_agent.get_next_path_position()

	var direction := current_pos.direction_to(next_pos)
	velocity = direction * movement_speed
	move_and_slide()

	update_animation(direction)

# Animazione caricata in base a _physics_process
func update_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		sprite.play("walk_right" if direction.x > 0 else "walk_left")
	else:
		sprite.play("walk_down" if direction.y > 0 else "walk_up")



#Funzione per il movimento random di un NPC
func start_random_movement() -> void:
	if is_player:
		return;
	
	# Temporizziamo le pause tra un movimento e l'altro degli NPC
	randomize()
	move_timer.wait_time = randi_range(2,5)
	move_timer.start()

func _onTimer_timeout() -> void:
	
	var rand_x = randf_range(-100,100)
	var rand_y = randf_range(-100,100)
	var new_target = global_position + Vector2(rand_x, rand_y)
	
	set_target(new_target)
	start_random_movement()
