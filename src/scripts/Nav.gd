extends Node2D

# Enables better intellisense
var sm: NSceneManager = SceneManager

func _on_home_pressed():
	sm.SwitchScene("Main")


func _on_reset_pressed():
	sm.RestartScene()


func _on_exit_pressed():
	sm.QuitGame()
