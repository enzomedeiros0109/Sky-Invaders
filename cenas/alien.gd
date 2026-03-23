extends CharacterBody2D

@onready var timeMovement = $TimerMovimento
@onready var spawn_point = $SpawnPoint
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_alien = $SpriteAlien
@onready var colisionShape = $CollisionShape2D
@onready var colisionShape2 = $Area2D/CollisionShape2D

@onready var audioExplosion = $AudioExplosion
@onready var audioMissil = $AudioMissil

var Missil = preload("res://cenas/AlienLaser.tscn")
var origin = 0
var distance = 30
var passo = 7
var direction = 1
var explosion_step = 1

signal eliminatedAlien(alien)

func _ready():
	timeMovement.start()
	origin = self.position.x
	animated_sprite.visible = false
	

	
func _on_timer_movimento_timeout():
	self.position.x += direction * passo
	if self.position.x >= origin + distance - 10 or self.position.x <= origin - distance:
		direction *= -1

func explosion():
	timeMovement.stop()
	colisionShape.set_deferred("disabled", true)
	colisionShape2.set_deferred("disabled", true)
	sprite_alien.visible = false
	animated_sprite.visible = true
	animated_sprite.play("exp_1")
	audioExplosion.play()
	
	
func elimination():
	emit_signal("eliminatedAlien", self)
	
	# Move o audio para o pai antes de deletar o alien
	var parent = get_parent()
	
	if get_parent() != null:
		remove_child(audioExplosion)
		parent.add_child(audioExplosion)
		audioExplosion.finished.connect(func(): audioExplosion.queue_free())
		get_parent().call_deferred("remove_child", self)
	queue_free()
	
func disparar():
	audioMissil.play()
	var missil = Missil.instantiate()
	missil.global_position = spawn_point.global_position
	get_parent().add_child(missil)

func _on_area_2d_body_entered(body):
	if is_queued_for_deletion():
		return
	if body.is_in_group("tanque") || body.is_in_group("blocos"):
		body.destruir()
		explosion()
		
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "exp_1":
		animated_sprite.play("exp_2")
	elif animated_sprite.animation == "exp_2":
		animated_sprite.play("exp_3")
	elif animated_sprite.animation == "exp_3":
		elimination()
		
