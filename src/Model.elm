module Model exposing (..)


type alias Model =
    { overall : IngredientsSection
    , formulas : List IngredientsSection
    }


type alias IngredientsSection =
    { name : String
    , ingredients : List Ingredient
    }


type alias Ingredient =
    { name : String
    , percent : Float
    }


type IngredientsSectionId
    = Overall
    | Formula Int


type Msg
    = ChangeIngredientName IngredientsSectionId Int String
    | ChangeIngredientPercent IngredientsSectionId Int String
    | RemoveIngredient IngredientsSectionId Int
    | AddIngredient IngredientsSectionId Int
