extends Area2D

var direccion : Vector2
var velocidad : float = 175

@export var tipo : Recogibles
@export var referencia_jugador : CharacterBody2D:
	set(value):
		referencia_jugador = value
		tipo.referencia_jugador = value

func _ready():
	$Sprite2D.texture = tipo.sprite
	
func _physics_process(delta):
	if referencia_jugador:
		direccion = (referencia_jugador.position - position).normalized()
		position += direccion * velocidad * delta

func _on_body_entered(body):
	tipo.activate()
	queue_free()
