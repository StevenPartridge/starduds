extends Node

func _on_area_entered(area):
	print("AreaEntered")
	print(area)
	if area.get_parent().has_method("collect_powerup"):
		print("Collecting")
		area.get_parent().collect_powerup()
		queue_free()
	else:
		print(area)
