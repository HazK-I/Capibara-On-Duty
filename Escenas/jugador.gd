extends CharacterBody2D

var contenedor : Node2D
var speed : float = 150
var vida : float = 100 :
	set(value):
		vida = value
		%Vida.value = value
		if vida <= 0:
			get_tree().paused = true

var enemigo_mascerca : CharacterBody2D
var enemigo_mascerca_distancia : float = INF

var xp : int = 0:
	set(value):
		xp = value
		%Experiencia.value = value
var total_exp : int = 0
var nivel : int = 0:
	set(value):
		nivel = value
		%Nivel.text = "Nivel " + str(value)
		%Opciones.mostrar_opciones()
		
		if nivel >= 3:
			%Experiencia.max_value = 10
		elif nivel >= 10:
			%Experiencia.max_value = 15
		elif  nivel >= 20:
			%Experiencia.max_value = 25
		elif nivel >= 30:
			%Experiencia.max_value = 40

func _physics_process(delta):
	if enemigo_mascerca:
		enemigo_mascerca_distancia = enemigo_mascerca.separacion
		
	else:
		enemigo_mascerca_distancia = INF
	
	velocity = Input.get_vector("izquierda","derecha","arriba","abajo") * speed
	move_and_collide(velocity * delta)
	
	ver_exp()
	
	actualizar_animacion()

func actualizar_animacion():
	if velocity.x != 0:
		%Animacion.flip_h = velocity.x < 0
	
	if velocity != Vector2.ZERO:
		%Animacion.play("Caminar")
	else:
		%Animacion.stop()

func tomar_daño(cantidad):
	vida -= cantidad

func _on_hit_box_body_entered(body):
	tomar_daño(body.daño)

func _on_timer_timeout():
	%Colision.set_deferred("disabled", true)
	%Colision.set_deferred("disabled", false)

func ganar_exp(cantidad):
	xp += cantidad
	total_exp += cantidad
	
func ver_exp():
	if xp > %Experiencia.max_value:
		xp -= %Experiencia.max_value
		nivel += 1

func _on_absorber_area_entered(area: Area2D) -> void:
	if area.has_method("seguir"):
		area.follow(self)
