class_name Sink extends Activatable

func activate(player: Player) -> bool:
	if player.item_name == "":
		player.item_name = "Water"
		player.item_icon.texture = load("res://food/Water.png")
		player.item_icon.visible = true
		player = null
		return true
	else:
		return false

func can_activate(player: Player) -> bool:
	if player.item_name != "":
		return false
	else:
		Globals.set_prompt_display.emit("Press [Space] to pickup Water.")
		return true
