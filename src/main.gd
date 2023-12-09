extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass




func _on_button_pressed_level_1():
	SceneManager.SwitchScene("level1")
	
func _on_button_pressed():
	SceneManager.SwitchScene("level2")
