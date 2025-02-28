extends Node

func _ready():
	pass

func _on_changeSceneButton_pressed():
	get_tree().reload_current_scene()
