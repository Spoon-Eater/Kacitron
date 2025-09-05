extends Control

func _process(delta: float) -> void:
	$MarginContainer/Label.text = str($"../..".velocity.length())
