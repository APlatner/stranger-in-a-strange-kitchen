class_name ServingPlate
extends Activatable

@onready var food_scene: PackedScene = preload("res://food.tscn") as PackedScene
@onready var requestable_entrees: Array[String] = [
	"Pizza", "Steak Dinner", "Fish Dinner",
]
@onready var requestable_appetizers: Array[String] = [
	"Salad", "Garlic Bread", "Cauliflower Soup"
]
@onready var requestable_desserts: Array[String] = [
	"Birthday Cake", "Pie",
]
var foods: Array[String]

func random_order():
	foods.resize(3)
	foods[0] = requestable_appetizers[randi_range(0, requestable_appetizers.size() - 1)]
	foods[1] = requestable_entrees[randi_range(0, requestable_entrees.size() - 1)]
	foods[2] = requestable_desserts[randi_range(0, requestable_desserts.size() - 1)]
	$Sprite1.texture = null
	$Sprite2.texture = null
	$Sprite3.texture = null
	Globals._update_appetizer_label.emit(foods[0])
	Globals._update_entree_label.emit(foods[1])
	Globals._update_dessert_label.emit(foods[2])

func activate(player: Player) -> bool:
	if not can_activate(player):
		return false
	var index = foods.find(player.item_name)
	if not $Sprite1.texture:
		$Sprite1.texture = load("res://food/" + player.item_name + ".png")
	elif not $Sprite2.texture:
		$Sprite2.texture = load("res://food/" + player.item_name + ".png")
	elif not $Sprite3.texture:
		$Sprite3.texture = load("res://food/" + player.item_name + ".png")
	foods.erase(player.item_name)
	player.item_name = ""
	player.item_icon.visible = false
	if foods.size() == 0:
		Globals.add_point_display.emit(3)
	return true

func can_activate(player: Player) -> bool:
	if foods.find(player.item_name) > -1:
		Globals.set_prompt_display.emit("Press [Space] to add " + player.item_name + " to serving platter.")
		return true
	else:
		return false
