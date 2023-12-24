extends Node

func _on_area_entered(area):
	if area.get_parent().has_method("collect_powerup"):
		area.get_parent().collect_powerup()
		queue_free()
