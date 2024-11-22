extends Node

var Transmilenio_Obst = preload("res://Escenas/Transmilenio.tscn")
var Roca_Obst = preload("res://Escenas/basura.tscn")
var Basura_Obst = preload("res://Escenas/Roca.tscn")
var Valla_Obst = preload("res://Escenas/valla.tscn")
var Cartel_Obst = preload("res://Escenas/Cartel.tscn")
var TiposObst := [Roca_Obst, Basura_Obst, Valla_Obst, Cartel_Obst]
var obstacles : Array
var Transmi_heights : = [485, 485]
var Cartel_heights := [500, 500]

const Moto_Start = Vector2i(142, 502)
const Cam_Start = Vector2i(576, 324)

var difficulty
const Max_difficulty : int = 2

var high_score : int
var score : int
var speed : float

const Puntaje : int = 10
const Start_Speed : float = 10.0
const Max_Speed : int = 25
const speedM : int = 5000
var screen_size : Vector2i
var ground_height : int
var Iniciar : bool
var last_obs

func _ready():
	screen_size = get_window().size
	ground_height = $Piso.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()
	
func new_game():
	$Music.play()
	score = 0
	show_score()
	Iniciar = false
	get_tree().paused = false
	difficulty = 0
	
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	$Moto.position = Moto_Start
	$Moto.velocity = Vector2i(0,0)
	$Camera2D.position = Cam_Start
	$Piso.position = Vector2i(0,0)
	
	$Hud.get_node("Iniciar").show()
	$GameOver.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Iniciar:
		speed = Start_Speed + score / speedM
		if speed > Max_Speed:
			speed = Max_Speed
		adjust_difficulty()
		
		generate_Obst()
			
		$Moto.position.x += speed
		$Camera2D.position.x += speed
		score += speed
		show_score()
		
		if $Camera2D.position.x - $Piso.position.x > screen_size.x * 1.5:
			$Piso.position.x += screen_size.x
			
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		if Input.is_action_pressed("ui_accept"):
			Iniciar = true
			$Hud.get_node("Iniciar").hide()

func generate_Obst():
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var ObstaculosTipos = TiposObst[randi() % TiposObst.size()]
		var obs
		var max_obs = difficulty + 1 
		for i in range(randi() % max_obs +1):
			obs = ObstaculosTipos.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x : int = screen_size.x + score + 100 + (i * 100)
			var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y /2) + 5
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
			
		if difficulty == Max_difficulty:
			if (randi() % 2) == 0:
				obs = Transmilenio_Obst.instantiate()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = Transmi_heights[randi() % Transmi_heights.size()]
				add_obs(obs, obs_x, obs_y)
			else:
				# Agrega el obstáculo Cartel
				obs = Cartel_Obst.instantiate()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = Cartel_heights[randi() % Cartel_heights.size()]
				add_obs(obs, obs_x, obs_y)
		
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)	

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body):
	if body.name == "Moto":
		game_over()
		
func show_score():
	$Hud.get_node("PuntajeHud").text = "Puntaje: " + str(score / Puntaje)

func check_high_score():
	if score > high_score:
		high_score = score
		$Hud.get_node("Record").text = "Record: " + str(high_score / Puntaje)
		
func adjust_difficulty():
	difficulty = score / speedM
	if difficulty > Max_difficulty:
		difficulty = Max_difficulty

func game_over():
	check_high_score()
	get_tree().paused = true
	Iniciar = false
	$DeathSound.play()
	$Music.stop()
	$GameOver.show()
