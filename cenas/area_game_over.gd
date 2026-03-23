extends Area2D

func _on_area_entered(area):
	if area.is_in_group("aliens"):
		var pontos = get_parent().pontos
		SaveManager.salvar(pontos)
		get_tree().change_scene_to_file("res://cenas/game_over.tscn")

	
	
	
