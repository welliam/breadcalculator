module Constants exposing (blankIngredient, init)

import Model exposing (Model)


blankIngredient : Model.Ingredient
blankIngredient =
    { name = "", percent = 0, kind = Model.Flour }


init : ( Model, Cmd msg )
init =
    ( { overall =
            { name = "Overall"
            , ingredients = [ { name = "bread flour", percent = 100, kind = Model.Flour } ]
            }
      , formulas =
            [ { name = "Final"
              , ingredients = [ { name = "bread flour", percent = 100, kind = Model.Flour } ]
              }
            ]
      , name = "formula"
      , weight = 700
      , prefermentedFlour = 15
      }
    , Cmd.none
    )
