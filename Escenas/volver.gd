extends TextureButton

func _ready():
	visible = false

func _process(_delta):
	if get_tree().paused == true and owner.vida <= 0 and visible == false:
		visible = true

func _on_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/menu_principal.tscn")
