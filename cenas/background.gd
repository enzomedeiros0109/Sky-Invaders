extends Node2D

@onready var camadaCima = $CamadaCima
@onready var camadaBaixo = $CamadadBaixo
@onready var timer = $Timer

var backgrounds = [
	preload("res://Assets Space Invades/Sprites/background_1.jpg"),
	preload("res://Assets Space Invades/Sprites/background_2.png"),
	preload("res://Assets Space Invades/Sprites/background_3.png")
]

var indice = 0
var duracao_fade = 1.5

func _ready():
	camadaBaixo.texture = backgrounds[0]
	camadaCima.modulate.a = 0.0
	camadaBaixo.centered = false
	camadaCima.centered = false
	timer.wait_time = 4.0
	timer.start()
	
func _on_timer_timeout():
	indice += 1
	camadaCima.texture = backgrounds[indice]
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(camadaCima, "modulate:a", 1.0, duracao_fade)
	tween.tween_property(camadaBaixo, "modulate:a", 0.0, duracao_fade)
	
	if indice == 2:
		indice = -1
	
	await tween.finished
	camadaBaixo.texture = camadaCima.texture
	camadaBaixo.modulate.a = 1.0
	camadaCima.modulate.a = 0.0
	
	
