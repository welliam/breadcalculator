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
    case ( percent, String.toInt percent ) of
        ( "", _ ) ->
            { ingredient | percent = 0 }

        ( _, Ok x ) ->
            { ingredient | percent = x }

        ( _, Err _ ) ->
            ingredient


removeNth : Int -> List a -> List a
removeNth index list =
    case ( index, list ) of
        ( _, [] ) ->
            []

        ( 0, head :: rest ) ->
            rest

        ( i, head :: rest ) ->
            head :: removeNth (i - 1) rest


addAfter : Int -> List a -> a -> List a
addAfter index list x =
    case ( index, list ) of
        ( _, [] ) ->
            [ x ]

        ( 0, head :: rest ) ->
            head :: x :: rest

        ( i, head :: rest ) ->
            head :: addAfter (i - 1) rest x


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

        RemoveIngredient nth ->
            ( { ingredients =
                    removeNth nth model.ingredients
              }
            , Cmd.none
            )

        AddIngredient nth ->
            ( { ingredients =
                    addAfter nth model.ingredients Constants.blankIngredient
              }
            , Cmd.none
            )
