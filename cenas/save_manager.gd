extends Node

const caminho = "user://save.json"
var recorde := 0
var tempo = ""

func _ready():
	carregar()
	
func salvar(pontos):
	if pontos > recorde:
		recorde = pontos
	var arquivo = FileAccess.open(caminho, FileAccess.WRITE)
	arquivo.store_string(JSON.stringify({"recorde": recorde}))
	arquivo.close()
	
func carregar():
	if not FileAccess.file_exists(caminho):
		return
	var arquivo = FileAccess.open(caminho, FileAccess.READ)
	var dados = JSON.parse_string(arquivo.get_as_text())
	arquivo.close()
	if dados and dados.has("recorde"):
		recorde = dados["recorde"]
