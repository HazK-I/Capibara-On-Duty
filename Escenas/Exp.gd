extends Recogibles
class_name exp

@export var xp : float

func activate():
	super.activate()
	referencia_jugador.ganar_exp(xp)
