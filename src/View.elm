module View exposing (view)

import Constants
import Html exposing (Attribute, button, div, input, text)
import Html.Attributes exposing (attribute, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (..)


textInput : List (Attribute Msg) -> String -> Html.Html Msg
textInput attributes inputValue =
    input
        (attribute "type" "text" :: value inputValue :: attributes)
        []


minusButton : Int -> Html.Html Msg
minusButton i =
    button [ onClick (RemoveIngredient i) ] [ text "-" ]


plusButton : Int -> Html.Html Msg
plusButton i =
    button [ onClick (AddIngredient i) ] [ text "+" ]


formatIngredient : Bool -> Int -> Ingredient -> Html.Html Msg
formatIngredient showMinusButton i ingredient =
    div []
        [ textInput [ onInput (ChangeIngredientName i) ] ingredient.name
        , textInput [ onInput (ChangeIngredientPercent i) ] (toString ingredient.percent)
        , plusButton i
        , if showMinusButton then
            minusButton i
          else
            text ""
        ]


formatIngredients : List Ingredient -> List (Html.Html Msg)
formatIngredients ingredients =
    case ingredients of
        [] ->
            [ text "OH FUCK" ]

        [ ingredient ] ->
            [ formatIngredient False 0 ingredient ]

        _ ->
            List.indexedMap (formatIngredient True) ingredients


formatStats : List Ingredient -> Html.Html Msg
formatStats ingredients =
    text (toString (List.sum (List.map .percent ingredients)))


view : Model -> Html.Html Msg
view model =
    div []
        (List.append
            (formatIngredients model.ingredients)
            [ formatStats model.ingredients ]
        )
