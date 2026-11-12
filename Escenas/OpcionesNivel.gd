extends VBoxContainer

@export var armas : HBoxContainer          # el HBoxContainer con los Contenedor (slots de armas)
@export var panel : NinePatchRect
@export var opciones_por_nivel : int = 3   # cuántas opciones se muestran al subir de nivel

var Opcion = preload("res://Escenas/campodeopcion.tscn")

const RUTA_ARMAS := "res://Recursos/Armas/"

var todas_las_armas : Array = []

func _ready():
	hide()
	panel.hide()
	cargar_todas_las_armas()

func cargar_todas_las_armas() -> void:
	todas_las_armas.clear()
	var dir = DirAccess.open(RUTA_ARMAS)
	if dir == null:
		push_warning("No se pudo abrir " + RUTA_ARMAS)
		return
	
	for archivo in dir.get_files():
		var nombre = archivo.trim_suffix(".remap")
		if not nombre.ends_with(".tres"):
			continue
		var recurso = load(RUTA_ARMAS + nombre)
		if recurso is arma:
			todas_las_armas.append(recurso)

func get_armas_equipadas() -> Array:
	var equipadas = []
	for contenedor in armas.get_children():
		if contenedor.armas != null:
			equipadas.append(contenedor.armas)
	return equipadas

func hay_espacio() -> bool:
	for contenedor in armas.get_children():
		if contenedor.armas == null:
			return true
	return false

func mostrar_opciones():
	var equipadas = get_armas_equipadas()
	var disponibles = []
	
	for item in equipadas:
		if item.es_mejorable():
			disponibles.append(item)
	
	if hay_espacio():
		for item in todas_las_armas:
			if item not in equipadas:
				disponibles.append(item)
	
	disponibles.shuffle()
	
	for hijo in get_children():
		hijo.queue_free()
	
	var cantidad = 0
	for item in disponibles.slice(0, opciones_por_nivel):
		add_opcion(item, item not in equipadas)
		cantidad += 1
	
	if cantidad == 0:
		return
	
	show()
	panel.show()
	get_tree().paused = true

func add_opcion(item, es_nueva : bool) -> void:
	var opcion = Opcion.instantiate()
	opcion.nueva = es_nueva
	opcion.armas = item
	add_child(opcion)

func elegir(item) -> void:
	if item in get_armas_equipadas():
		item.mejorar_arma()
	else:
		equipar_arma(item)
	cerrar_opcion()


func equipar_arma(item) -> void:
	for contenedor in armas.get_children():
		if contenedor.armas == null:
			contenedor.armas = item
			return


func cerrar_opcion():
	hide()
	panel.hide()
	get_tree().paused = false
