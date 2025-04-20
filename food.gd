class_name Food
extends Activatable

@export var food_name: String

func init(_name: String) -> void:
	food_name = _name
	var sprite := Sprite2D.new()
	var resource_path := "res://food/" + _name + ".png"
	sprite.texture = load(resource_path) as Texture2D
	add_child(sprite)

func activate(player: Player) -> bool:
	if player.item_name == "":
		player.item_name = food_name
		var resource_path := "res://food/" + food_name + ".png"
		player.item_icon.texture = load(resource_path) as Texture2D
		player.item_icon.visible = true
		queue_free()
		return true
	return false

func can_activate(player: Player) -> bool:
	if player.item_name == "":
		Globals.set_prompt_display.emit("Press [Space] to pickup " + food_name + ".")
		return true
	else:
		return false
