module Main exposing (flow)

import Model


weightIngredient : Float -> Ingredient -> WeightedIngredient
weightIngredient onePercentWeight i =
    { i | weight = i.percent * onePercentWeight }


processIngredientsSection : Float -> IngredientsSection -> WeightedIngredientsSection
processIngredientsSection weight section =
    { section | ingredients = map (weightIngredient weight) section.ingredients }



subtractIngredient : List Ingredient -> Ingredient -> List Ingredient
subtractIngredient ingredients ingredient =
    case ingredients of
        [] -> []
        i :: is -> if i.name == ingredient.name then

subtractSections : List Ingredient -> List Ingredient -> List Ingredient
subtractSections s1 [] = s1
subtractSections s1 s2 =

flow : IngredientSection -> List IngredientSection -> IngredientSection
flow
