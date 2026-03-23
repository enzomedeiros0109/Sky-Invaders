extends StaticBody2D

@onready var animation_player = $AnimationPlayer

var golpes = 0

func _ready():
	comprovar_golpes()
	
func destruir():
	golpes += 1
	comprovar_golpes()
	
func comprovar_golpes():
	if golpes == 0:
		animation_player.play("normal")
	elif golpes == 1:
		animation_player.play("danificado")
	elif golpes == 2:
		queue_free()
