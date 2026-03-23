extends Node

@onready var tempoLabel = $Label
var tempo_segundos: int = 0

func _ready():
	$Timer.start()
	
func _on_timer_timeout():
	tempo_segundos += 1
	var text = ""
	var minutos = tempo_segundos / 60
	var segundos = tempo_segundos % 60
	var textMinutos = ""
	var textSegundos = ""
	
	if minutos < 10:
		textMinutos = "0" + str(minutos)
	else:
		textMinutos = str(minutos)
	if segundos < 10:
		textSegundos = "0" + str(segundos)
	else:
		textSegundos = str(segundos)
	text = textMinutos + ":" + textSegundos
	tempoLabel.text = text
	SaveManager.tempo = text
