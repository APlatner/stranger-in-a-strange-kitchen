extends Node

signal _update_appetizer_label(name: String)
signal _update_entree_label(name: String)
signal _update_dessert_label(name: String)
signal _clear_recipe_display()
signal _add_recipe_display(recipe: Recipe)
signal set_prompt_display(text: String)
signal clear_content_display()
signal add_content_display(ingredient_name: String)
signal add_point_display(points: int)

static var score: int = 0
static var game_time: float = 0.0
static var baked_potato: CompressedTexture2D = preload("res://food/water.png")
