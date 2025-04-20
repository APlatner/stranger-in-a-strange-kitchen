class_name Activatable
extends Area2D

func _ready():
	connect("body_entered", on_area_2d_body_entered)
	connect("body_exited", on_area_2d_body_exited)

func on_area_2d_body_entered(body: Node2D):
	if body is Player:
		(body as Player).activatables.push_back(self)
		(body as Player).update_prompt()

func on_area_2d_body_exited(body: Node2D):
	if body is Player:
		set_display(false)
		(body as Player).activatables.erase(self)
		(body as Player).update_prompt()

func activate(_player: Player) -> bool:
	return false

func can_activate(_player: Player) -> bool:
	return false

func set_display(_active: bool):
	pass
