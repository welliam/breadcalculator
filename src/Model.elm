module Model exposing (..)


type alias Model =
    { overall : IngredientSection
    , formulas : List IngredientSection
    }


type alias IngredientsSection =
    { name : String
    , ingredients : List Ingredient
    }


type alias Ingredient =
    { name : String
    , percent : Float
    }


type Msg
    = ChangeIngredientName Int String
    | ChangeIngredientPercent Int String
    | RemoveIngredient Int
    | AddIngredient Int
