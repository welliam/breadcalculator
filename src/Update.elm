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
    case ( percent, String.toFloat percent ) of
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


updateOverallSection : Model -> (IngredientSection -> IngredientSection) -> Model
updateOverallSection model update =
    { model | overall = update model.overall }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ChangeIngredientName nth name ->
            ( updateOverallSection model
                (\section ->
                    { section
                        | ingredients =
                            updateNth nth
                                section.ingredients
                                (updateIngredientName name)
                    }
                )
            , Cmd.none
            )

        ChangeIngredientPercent nth percent ->
            ( updateOverallSection model
                (\section ->
                    { section
                        | ingredients =
                            updateNth nth
                                section.ingredients
                                (updateIngredientPercent percent)
                    }
                )
            , Cmd.none
            )

        RemoveIngredient nth ->
            ( updateOverallSection model
                (\section ->
                    { section
                        | ingredients = removeNth nth section.ingredients
                    }
                )
            , Cmd.none
            )

        AddIngredient nth ->
            ( updateOverallSection model
                (\section ->
                    { section
                        | ingredients =
                            addAfter nth section.ingredients Constants.blankIngredient
                    }
                )
            , Cmd.none
            )
