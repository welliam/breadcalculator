module Constants exposing (blankIngredient, init)

import Model exposing (Model)


blankIngredient : Model.Ingredient
blankIngredient =
    { name = "", percent = 0 }


init : ( Model, Cmd msg )
init =
    ( { overall =
            { name = "Overall"
            , ingredients = [ { name = "hello", percent = 100 } ]
            }
      , formulas = []
      }
    , Cmd.none
    )
