module Model exposing (..)


type alias Model =
    { ingredients : List Ingredient
    }


type alias Ingredient =
    { name : String, percent : Int }


type Msg
    = ChangeIngredientName Int String
    | ChangeIngredientPercent Int String
    | RemoveIngredient Int
    | AddIngredient Int
