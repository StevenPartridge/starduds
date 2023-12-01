extends Node


func _on_area_2d_area_entered(body):
	print("HEPYA")
	if body.has_method("collect_coin"):
		body.collect_coin()
		queue_free()


func _on_area_entered(area):
	print("HEPYA")
	if area.has_method("collect_coin"):
		area.collect_coin()
		queue_free()
