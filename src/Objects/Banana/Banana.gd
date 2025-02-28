extends Node2D

signal banana_collected

onready var _animated_sprite = $AnimatedSprite

func _on_coin_body_entered(body):
	if body.has_method("enable_double_jump"):
		body.enable_double_jump()
	$SoundCoin.play()
	_animated_sprite.animation = "collected"    
	emit_signal("banana_collected")

func _on_AnimatedSprite_animation_finished():
	if _animated_sprite.animation == "collected":
		queue_free()
