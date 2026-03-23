extends Node

@onready var timer_disparo = $TimerDisparar

var Alien = preload("res://cenas/alien.tscn")
var listaAliens = []
# 1 - 2 -> Fácil | 3 - 4 -> Médio | > 4 -> Difícil
var dificuldade = 1
var linhaAliens = 4
var colunaAliens = 4
#var todosEliminados = false

func _ready():
	listaAliens.clear()
	spawnar_aliens()
	timer_disparo.wait_time = randf_range(1, 2)
	timer_disparo.start()

func spawnar_aliens():
	if dificuldade == 3 or dificuldade == 4:
		if linhaAliens == 4 and colunaAliens == 4:
			linhaAliens += 1
			colunaAliens += 1
	if dificuldade > 4:
		if linhaAliens == 5 and colunaAliens == 5:
			linhaAliens += 1
			colunaAliens += 2
		
	listaAliens.clear()
	for j in range(linhaAliens):
		listaAliens.append([])
		for i in range(colunaAliens):
			var alien = Alien.instantiate()
			alien.global_position = Vector2(50+24*i, 20+26*j)
			self.add_child(alien)
			listaAliens[j].append(alien)
			alien.connect("eliminatedAlien", Callable(self, "eliminar_alien"))
			alien.connect("eliminatedAlien", Callable(get_parent(), "somar_pontos_alien"))
			
			
func eliminar_alien(a):
	for fila in listaAliens:
		for i in range(len(fila)):
			if a == fila[i]:
				fila.remove_at(i)
				break
	if todos_eliminados():
		get_parent().nova_wave()
		dificuldade += 1
		spawnar_aliens()

func todos_eliminados():
	for fila in listaAliens:
		if not fila.is_empty():
			return false
	
	return true

func _on_timer_descida_timeout():
	for fila in listaAliens:
		for alien in fila:
			if is_instance_valid(alien):
				alien.position.y += 21


func _on_timer_disparar_timeout() -> void:
	var lista_aliens_vivos = []
	for fila in listaAliens:
		for alien in fila:
			if is_instance_valid(alien) and !alien.is_queued_for_deletion():
				lista_aliens_vivos.append(alien)
	
	if lista_aliens_vivos:
		if dificuldade == 1 or dificuldade == 2:
			var indice = int(floor(randf_range(0, len(lista_aliens_vivos)-1)))
			lista_aliens_vivos[indice].disparar()
			timer_disparo.wait_time = randf_range(1, 5)
		elif dificuldade == 3 or dificuldade == 4:
			for i in range(2):
				var indice = int(floor(randf_range(0, len(lista_aliens_vivos)-1)))
				lista_aliens_vivos[indice].disparar()
				timer_disparo.wait_time = randf_range(1, 3)
		elif dificuldade > 4:
			for i in range(3):
				var indice = int(floor(randf_range(0, len(lista_aliens_vivos)-1)))
				lista_aliens_vivos[indice].disparar()
				timer_disparo.wait_time = randf_range(1, 2)
			
