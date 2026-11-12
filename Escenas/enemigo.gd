extends CharacterBody2D

@export var jugador_reference : CharacterBody2D
var daño_pop = preload("res://Escenas/daño.tscn")
var direction : Vector2
var speed : float = 50
var daño : float
var empuje : Vector2
var separacion : float

var dejar = preload("res://Escenas/recogibles.tscn") 

var vida : float:
	set (value):
		vida = value
		if vida <= 0:
			dejar_objeto()
			queue_free()

var enojo : bool = false:
	set(value):
		enojo = value
		if (value):
			var mat = ShaderMaterial.new()
			mat.shader = load("res://Shaders/enojo.gdshader")
			$AnimatedSprite2D.material = mat
			scale = Vector2(1.2,1.2)
			vida = vida * 1.5

var type : Enemigo:
	set(value):
		type = value
		$AnimatedSprite2D.sprite_frames = value.frames
		$AnimatedSprite2D.play("caminar")
		scale = value.escala
		daño = value.daño
		vida = value.vida

func _physics_process(delta):
	ver_separacion(delta)
	empuje_actualiza(delta)
	
func ver_separacion(_delta):
	var separation = (jugador_reference.position - position).length()
	if separation >= 1250 and not enojo:
		queue_free()

	if separation < jugador_reference.enemigo_mascerca_distancia:
		jugador_reference.enemigo_mascerca = self

func empuje_actualiza(delta):
	velocity = (jugador_reference.position - position).normalized() * speed
	empuje = empuje.move_toward(Vector2.ZERO, 1)
	velocity += empuje
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	var colision = move_and_collide(velocity * delta)
	if colision:
		colision.get_collider().empuje = (colision.get_collider().global_position
		 - global_position).normalized() * 50

func pop_daño(cantidad):
	var popup = daño_pop.instantiate()
	popup.text = str(cantidad)
	popup.position = position + Vector2(-50, -25)
	get_tree().current_scene.add_child(popup)

func tomar_daño(cantidad : float, origen : Vector2 = Vector2.ZERO, fuerza_empuje : float = 0.0):
	vida -= cantidad
	
	pop_daño(cantidad)
	
	if fuerza_empuje > 0:
		empuje = (global_position - origen).normalized() * fuerza_empuje

	$AnimatedSprite2D.modulate = Color(0.558, 0.0, 0.0, 1.0)
	create_tween().tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.1)

	if vida <= 0:
		queue_free()

func dejar_objeto():
	if type.dejar.size() == 0:
		return
	
	var objeto = type.dejar.pick_random()
	
	var objeto_a_tirar = dejar.instantiate()
	
	objeto_a_tirar.tipo = objeto
	objeto_a_tirar.position = position
	objeto_a_tirar.referencia_jugador = jugador_reference
	
	get_tree().current_scene.call_deferred("add_child", objeto_a_tirar)
