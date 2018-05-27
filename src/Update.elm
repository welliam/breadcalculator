module Update exposing (update)

import Constants
import Model exposing (..)


updateNth : Int -> List a -> (a -> a) -> List a
updateNth nth list f =
    case ( list, nth ) of
        ( [], i ) ->
            []

        ( head :: rest, 0 ) ->
            f head :: rest

        ( head :: rest, i ) ->
            head :: updateNth (nth - 1) rest f


updateIngredientName : String -> Ingredient -> Ingredient
updateIngredientName name ingredient =
    { ingredient | name = name }


updateIngredientPercent : String -> Ingredient -> Ingredient
updateIngredientPercent percent ingredient =
    case String.toInt percent of
        Ok x ->
            { ingredient | percent = x }

        Err _ ->
            { ingredient | percent = 0 }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ChangeIngredientName nth name ->
            ( { ingredients =
                    updateNth nth
                        model.ingredients
                        (updateIngredientName name)
              }
            , Cmd.none
            )

        ChangeIngredientPercent nth percent ->
            ( { ingredients =
                    updateNth nth
                        model.ingredients
                        (updateIngredientPercent percent)
              }
            , Cmd.none
            )
