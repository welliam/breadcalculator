module View exposing (view)

import Constants
import Html exposing (Attribute, button, div, h2, input, text)
import Html.Attributes exposing (attribute, value)
import Html.Events exposing (on, onClick, onInput, targetValue)
import Json.Decode as Json
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


onBlur : (String -> Msg) -> Attribute Msg
onBlur tagger =
    on "blur" (Json.map tagger targetValue)


formatIngredient : Bool -> Int -> Ingredient -> Html.Html Msg
formatIngredient showMinusButton i ingredient =
    div []
        [ textInput [ onBlur (ChangeIngredientName i) ] ingredient.name
        , textInput [ onBlur (ChangeIngredientPercent i) ] (toString ingredient.percent)
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


formatIngredientsSection : IngredientSection -> Html.Html Msg
formatIngredientsSection section =
    div [] [ h2 [] [ text section.name ], div [] (formatIngredients section.ingredients) ]


formatStats : List Ingredient -> Html.Html Msg
formatStats ingredients =
    text (toString (List.sum (List.map .percent ingredients)))


view : Model -> Html.Html Msg
view model =
    div []
        [ formatIngredientsSection model.overall
        , formatStats model.overall.ingredients
        ]
