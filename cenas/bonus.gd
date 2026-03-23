extends Area2D

@export var velocidade = 90.0
@onready var colision = $CollisionShape2D

func _ready():
	visible = false

func _process(delta):
	rotation_degrees += velocidade * delta * 0.4
	

func _on_body_entered(body):
	if body.is_in_group("tanque"):
		colision.set_deferred("disabled", true)
		body.ativar_bonus()
		visible = false
	
