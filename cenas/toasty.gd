extends Node2D

@onready var sprite = $Sprite2D
@onready var audio = $AudioToasty
@export var velocidade = 100.0

var inicio = Vector2(-14.0, 268.0)
var fim = Vector2(12.0, 244.0)
var ativo = false
var indo = true
var esperando = false

func _ready():
	sprite.position = inicio

func _process(delta):
	if not ativo or esperando:
		return
	
	var destino = fim if indo else inicio
	sprite.position = sprite.position.move_toward(destino, velocidade * delta)
	
	if sprite.position == destino:
		if indo:
			esperando = true
			await get_tree().create_timer(1.0).timeout
			esperando = false
			indo = false
		else:
			ativo = false

func toasty():
	if ativo:
		return
	if randi_range(1, 10) >= 5:
		sprite.position = inicio
		ativo = true
		indo = true
		audio.play()
