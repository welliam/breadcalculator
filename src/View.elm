module View exposing (view)

import Constants
import Html exposing (Attribute, button, div, input, text)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick, onInput)
import Model exposing (..)


textInput : List (Attribute Msg) -> String -> Html.Html Msg
textInput attributes value =
    input
        (attribute "type" "text" :: attribute "value" value :: attributes)
        []


minusButton : Int -> Html.Html Msg
minusButton i =
    button [ onClick (RemoveIngredient i) ] [ text "-" ]


formatIngredient : Int -> Ingredient -> Html.Html Msg
formatIngredient i ingredient =
    div []
        [ textInput [ onInput (ChangeIngredientName i) ]
            ingredient.name
        , textInput [ onInput (ChangeIngredientPercent i) ] (toString ingredient.percent)
        , minusButton i
        ]


formatIngredientReadOnly : Ingredient -> Html.Html Msg
formatIngredientReadOnly ingredient =
    div []
        [ text ingredient.name
        , text (toString ingredient.percent)
        ]


view : Model -> Html.Html Msg
view model =
    div []
        (List.append
            (List.indexedMap formatIngredient
                model.ingredients
            )
            (List.map formatIngredientReadOnly
                model.ingredients
            )
        )
