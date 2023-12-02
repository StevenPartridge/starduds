extends Node

func _on_area_entered(area):
	if area.has_method("collect_coin"):
		area.collect_coin()
		queue_free()
