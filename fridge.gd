class_name Fridge extends Activatable

@onready var ingredients: Array[String] = [
	"Lettuce", "Berries", "Raw Steak", "Raw Fish",
	"Butter", "Cheese", "Milk", "Mushrooms", "Cauliflower",
]
@onready var inventory: VBoxContainer = $Inventory as VBoxContainer
var _player: Player = null

func _ready():
	connect("body_entered", on_area_2d_body_entered)
	connect("body_exited", on_area_2d_body_exited)
	var row_count := floorf(sqrt(ingredients.size())) as int
	var column_count := ceilf(ingredients.size() / (row_count as float)) as int
	var button_count := ingredients.size()
	for i in row_count:
		var hbox := HBoxContainer.new()
		hbox.name = "hbox" + str(i)
		inventory.add_child(hbox)
		if button_count < column_count:
			for x in button_count:
				var button := Button.new()
				button.name = ingredients[i * column_count + x]
				button.text = ingredients[i * column_count + x]
				button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
				button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
				var resource_path := "res://food/" + button.name + ".png"
				button.icon = load(resource_path) as Texture2D
				button.connect("pressed", on_button_press.bind(button.text))
				hbox.add_child(button)
		else:
			button_count -= column_count
			for x in column_count:
				var button := Button.new()
				button.name = ingredients[i * column_count + x]
				button.text = ingredients[i * column_count + x]
				button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
				button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
				var resource_path := "res://food/" + button.name + ".png"
				button.icon = load(resource_path) as Texture2D
				button.connect("pressed", on_button_press.bind(button.text))
				hbox.add_child(button)

func activate(player: Player) -> bool:
	if player.item_name == "":
		if inventory.visible:
			_player = null
			inventory.visible = false
		else:
			_player = player
			inventory.visible = true
		return true
	else:
		return false

func can_activate(player: Player) -> bool:
	if player.item_name == "":
		Globals.set_prompt_display.emit("Press [Space] to open fridge.")
		return true
	else:
		return false

func on_area_2d_body_exited(body: Node2D):
	if body is Player:
		inventory.visible = false
		_player = null
		(body as Player).activatables.erase(self)
		(body as Player).update_prompt()

func on_button_press(button_name: String):
	if _player:
		_player.item_name = button_name
		var resource_path := "res://food/" + button_name + ".png"
		_player.item_icon.texture = load(resource_path) as Texture2D
		_player.item_icon.visible = true
		_player = null
		inventory.visible = false
