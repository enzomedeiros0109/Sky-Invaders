extends Node2D

@onready var recordeLabel = $RecordeLabel
@onready var tempoLabel = $TempoLabel

func _ready():
	recordeLabel.text = "Recorde:\n" + str(SaveManager.recorde)
	tempoLabel.text = "Tempo:\n" + str(SaveManager.tempo)
func _on_botao_reiniciar_pressed():
	get_tree().change_scene_to_file("res://cenas/main.tscn")
