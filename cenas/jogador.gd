extends CharacterBody2D

@export var laser = preload("res://cenas/laser.tscn")

@onready var pontoLaser = $PontoLaser
@onready var timer_disparo = $TimerDisparo
@onready var animation_player = $AnimationJogador
@onready var timer_bonus = $TimerBonus
@onready var timer_tiro_bonus = $TimerTiroBonus
@onready var colision = $CollisionShape2D

@onready var audioBonus = $AudioBonus
@onready var audioExplosion = $AudioExplosion
var shoot_sound = preload("res://Assets Space Invades/sfx/audioMissilJogador.mp3")

var directionX = Vector2()
var directionY = Vector2()
var speed = 100.0
var canShoot = true
var destruido = false
signal morreu

func reproduzirAudioMissil():
	var audio = AudioStreamPlayer.new()
	audio.volume_db = -30
	audio.pitch_scale = 1.0
	audio.stream = shoot_sound
	audio.finished.connect(func(): audio.queue_free())
	get_parent().add_child(audio)
	audio.play()

func _physics_process(_delta):
	directionX = Input.get_axis("ui_left", "ui_right")
	directionY = Input.get_axis("ui_up", "ui_down")
	
	velocity.x = directionX * speed if directionX != 0 else move_toward(velocity.x, 0, speed)
	velocity.y = directionY * speed if directionY != 0 else move_toward(velocity.y, 0, speed)
		
	if Input.is_action_just_pressed("shoot") and canShoot:
		canShoot = false
		timer_disparo.start()
		reproduzirAudioMissil()
		var l = laser.instantiate()
		l.global_position = pontoLaser.global_position
		get_parent().add_child(l)

	move_and_slide()
	
func bonus_shoot():
	timer_disparo.wait_time(0.3)
	var l = laser.instantiate()
	l.global_position = pontoLaser.global_position
	get_parent().add_child(l)

func destruir():
	audioExplosion.play()
	animation_player.play("destruido")
	destruido = true
	emit_signal("morreu")
	eliminado()

func eliminado():
	if !self.is_queued_for_deletion():
		var pontos = get_parent().pontos
		SaveManager.salvar(pontos)
		speed = 0
		canShoot = false
		colision.set_deferred("disabled", true)
		await get_tree().create_timer(2.0).timeout
		get_tree().call_deferred("change_scene_to_file", "res://cenas/game_over.tscn")
		
func _on_timer_disparo_timeout():
	canShoot = true

func ativar_bonus():
	audioBonus.play()
	await audioBonus.finished
	timer_tiro_bonus.wait_time = 0.3
	timer_tiro_bonus.start()
	timer_bonus.wait_time = 5.0
	timer_bonus.start()

func _on_timer_tiro_bonus_timeout():
	if canShoot == false:
		return
	reproduzirAudioMissil()
	var l = laser.instantiate()
	l.global_position = pontoLaser.global_position
	get_parent().add_child(l)

func _on_timer_bonus_timeout():
	timer_tiro_bonus.stop()
