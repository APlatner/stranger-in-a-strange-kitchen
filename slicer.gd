class_name Slicer
extends Activatable

@onready var recipes: Array[Recipe] = [
		Recipe.new("Sliced_cheese", ["cheese"]),
	]
@onready var current_recipes: Array[Recipe] = recipes.duplicate()
@onready var food_scene: PackedScene = preload("res://food.tscn") as PackedScene
@onready var recipe_display: HBoxContainer = $RecipeDisplay as HBoxContainer
@onready var product: Label = $RecipeDisplay/Product as Label
@onready var ingredient_display: VBoxContainer = $RecipeDisplay/Ingredients as VBoxContainer

var ingredients: Array[String]

var running := false
var runtime := 0.0
var baketime := 10.0

func _process(delta: float):
	if running:
		runtime += delta
		$ProgressBar.value = runtime / baketime  * 100
	if runtime >= baketime:
		var food: Food = food_scene.instantiate() as Food
		food.init(current_recipes[0].product)
		food.global_position = global_position + Vector2.DOWN * 100
		get_parent().add_child(food)
		runtime = 0.0
		running = false
		ingredients = []
		current_recipes = recipes.duplicate()
		$ProgressBar.visible = false

func check_recipe():
	for ingredient in current_recipes[0].ingredients:
		if ingredients.find(ingredient) == -1:
			return
	running = true
	$ProgressBar.visible = true

func activate(player: Player) -> bool:
	if not can_activate(player):
		return false
	var success := false
	var temp_recipes: Array[Recipe] = current_recipes.duplicate()
	for recipe in temp_recipes:
		if recipe.ingredients.find(player.item_name) > -1:
			ingredients.push_back(player.item_name)
			success = true
		else:
			current_recipes.erase(recipe)
	if success:
		player.item_name = ""
		player.item_icon.visible = false
	check_recipe()
	return success

func can_activate(player: Player) -> bool:
	if player.item_name != "":
		if ingredients.find(player.item_name) > -1:
			return false
		for recipe in current_recipes:
			if recipe.ingredients.find(player.item_name) > -1:
				player.label.text = "press space to slice " + player.item_name
				product.text = recipe.product
				if recipe.ingredients.size() == 1:
					$RecipeDisplay/Ingredients/Ingredient1.text = recipe.ingredients[0]
					$RecipeDisplay/Ingredients/Ingredient2.text = ""
					$RecipeDisplay/Ingredients/Ingredient3.text = ""
				if recipe.ingredients.size() == 2:
					$RecipeDisplay/Ingredients/Ingredient1.text = recipe.ingredients[0]
					$RecipeDisplay/Ingredients/Ingredient2.text = recipe.ingredients[1]
					$RecipeDisplay/Ingredients/Ingredient3.text = ""
				if recipe.ingredients.size() == 3:
					$RecipeDisplay/Ingredients/Ingredient1.text = recipe.ingredients[0]
					$RecipeDisplay/Ingredients/Ingredient2.text = recipe.ingredients[1]
					$RecipeDisplay/Ingredients/Ingredient3.text = recipe.ingredients[2]
				return true
		return false
	else:
		return false

func set_display(active: bool):
	recipe_display.visible = active
