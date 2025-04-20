extends Node2D

@onready var serving_plate: ServingPlate = $Appliances/ServingPlate as ServingPlate
@onready var appetizer_label: Label = $Control/VBoxContainer/Orders/Appetizer/Label as Label
@onready var appetizer_icon: TextureRect = $Control/VBoxContainer/Orders/Appetizer/Icon as TextureRect
@onready var entree_label: Label = $Control/VBoxContainer/Orders/Entree/Label as Label
@onready var entree_icon: TextureRect = $Control/VBoxContainer/Orders/Entree/Icon as TextureRect
@onready var dessert_label: Label = $Control/VBoxContainer/Orders/Dessert/Label as Label
@onready var dessert_icon: TextureRect = $Control/VBoxContainer/Orders/Dessert/Icon as TextureRect
@onready var recipe_label: Label = $Control/VBoxContainer/Recipes as Label
@onready var recipe_container: VBoxContainer = $Control/VBoxContainer/RecipeContainer as VBoxContainer
@onready var content_label: Label = $Control/VBoxContainer/Contents as Label
@onready var content_box: HBoxContainer = $Control/VBoxContainer/ContentBox as HBoxContainer

func _init():
	Globals._update_appetizer_label.connect(set_appetizer_label)
	Globals._update_entree_label.connect(set_entree_label)
	Globals._update_dessert_label.connect(set_dessert_label)
	Globals._clear_recipe_display.connect(clear_recipe)
	Globals._add_recipe_display.connect(add_recipe)
	Globals.set_prompt_display.connect(set_prompt)
	Globals.clear_content_display.connect(clear_content)
	Globals.add_content_display.connect(add_content)
	Globals.add_point_display.connect(add_point)

func _process(_delta: float):
	if serving_plate.foods.size() == 0:
		serving_plate.random_order()

func set_appetizer_label(_name: String):
	appetizer_label.text = _name
	var resource_path := "res://food/" + _name + ".png"
	appetizer_icon.texture = load(resource_path) as Texture2D
	print("set label to ", _name)

func set_entree_label(_name: String):
	entree_label.text = _name
	var resource_path := "res://food/" + _name + ".png"
	entree_icon.texture = load(resource_path) as Texture2D
	print("set label to ", _name)

func set_dessert_label(_name: String):
	dessert_label.text = _name
	var resource_path := "res://food/" + _name + ".png"
	dessert_icon.texture = load(resource_path) as Texture2D
	print("set label to ", _name)

func clear_recipe():
	recipe_label.text = ""
	for child in recipe_container.get_children():
		child.queue_free()

func add_recipe(recipe: Recipe):
	recipe_label.text = "Recipes"
	var hbox := HBoxContainer.new()
	hbox.name = "hbox"
	for ingredient in recipe.ingredients:
		var ingr := create_food_display(ingredient)
		hbox.add_child(ingr)
	var arrow: TextureRect = TextureRect.new()
	arrow.texture = load("res://arrow.png") as Texture2D
	arrow.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hbox.add_child(arrow)
	var product := create_food_display(recipe.product)
	hbox.add_child(product)
	recipe_container.add_child(hbox)

func create_food_display(_name: String) -> VBoxContainer:
	var vbox := VBoxContainer.new()
	var icon := TextureRect.new()
	var resource_path := "res://food/" + _name + ".png"
	icon.texture = load(resource_path) as Texture2D
	var label := Label.new()
	label.text = _name
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.custom_minimum_size.x = 10
	vbox.add_child(icon)
	vbox.add_child(label)
	return vbox

func set_prompt(text: String):
	$Control/Prompt.text = text

func clear_content():
	content_label.text = ""
	for child in content_box.get_children():
		child.queue_free()

func add_content(ingredient_name: String):
	content_label.text = "Contents"
	var food := create_food_display(ingredient_name)
	content_box.add_child(food)

func add_point(points: int):
	Globals.score += points
	$Control/VBoxContainer/Score.text = "Total Score: %d" % Globals.score
