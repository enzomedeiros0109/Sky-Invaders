extends Node
var pontos = 0
@onready var label_pontos = $Labels/LabelPontos
@onready var label_tempo = $Contador/Label
@onready var alien_group = $AlienGroup
@onready var jogador = $Jogador
@onready var bonus = $Bonus
@onready var toasty = $toasty


func _ready():
	jogador.morreu.connect(toasty.toasty)

func somar_pontos_alien(_alien):
	pontos += 100
	label_pontos.text = "Pontos: " + str(pontos)
		
	if pontos % 1000 == 0 and is_instance_valid(bonus):
		bonus.global_position = Vector2(randf_range(17.0, 236.0), randf_range(240.0, 210.0))
		bonus.collision_layer = 1
		bonus.get_node("CollisionShape2D").set_deferred("disabled", false)
		bonus.visible = true
	
func nova_wave():
	pontos += 500
		
	
