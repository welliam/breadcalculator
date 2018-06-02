module View exposing (view)

import Constants
import Html exposing (Attribute, button, div, h2, h3, input, span, text)
import Html.Attributes exposing (attribute, value)
import Html.Events exposing (on, onClick, onInput, targetValue)
import Json.Decode as Json
import Model exposing (..)


textInput : List (Attribute Msg) -> String -> Html.Html Msg
textInput attributes inputValue =
    input
        (attribute "type" "text" :: value inputValue :: attributes)
        []


minusButton : IngredientsSectionId -> Int -> Html.Html Msg
minusButton section i =
    button [ onClick (RemoveIngredient section i) ] [ text "-" ]


plusButton : IngredientsSectionId -> Int -> Html.Html Msg
plusButton section i =
    button [ onClick (AddIngredient section i) ] [ text "+" ]


onBlur : (String -> Msg) -> Attribute Msg
onBlur tagger =
    on "blur" (Json.map tagger targetValue)


formatIngredient : IngredientsSectionId -> Bool -> Int -> Ingredient -> Html.Html Msg
formatIngredient section showMinusButton i ingredient =
    div []
        [ textInput [ onBlur (ChangeIngredientName section i) ] ingredient.name
        , textInput [ onBlur (ChangeIngredientPercent section i) ] (toString ingredient.percent)
        , plusButton section i
        , if showMinusButton then
            minusButton section i
          else
            text ""
        ]


formatIngredients : IngredientsSectionId -> List Ingredient -> List (Html.Html Msg)
formatIngredients section ingredients =
    case ingredients of
        [] ->
            [ text "OH FUCK" ]

        [ ingredient ] ->
            [ formatIngredient section False 0 ingredient ]

        _ ->
            List.indexedMap (formatIngredient section True) ingredients


formatIngredientsSection : IngredientsSectionId -> IngredientsSection -> Html.Html Msg
formatIngredientsSection sectionId section =
    div
        []
        [ h2 [] [ text section.name ]
        , div [] (formatIngredients sectionId section.ingredients)
        ]


formatStats : List Ingredient -> Html.Html Msg
formatStats ingredients =
    text (toString (List.sum (List.map .percent ingredients)))


statsSection : Model -> Html.Html Msg
statsSection model =
    div []
        [ div []
            [ span [] [ h3 [] [ text "weight" ] ]
            , textInput [ onBlur ChangeWeight ] (toString model.weight)
            ]
        , div []
            [ span [] [ h3 [] [ text "prefermented flour" ] ]
            , textInput [ onBlur ChangePrefermentedFlour ] (toString model.prefermentedFlour)
            ]
        ]


view : Model -> Html.Html Msg
view model =
    div []
        [ statsSection model
        , formatIngredientsSection Overall model.overall
        , div []
            (List.indexedMap
                (\nth section ->
                    formatIngredientsSection (Formula nth) section
                )
                model.formulas
            )
        , formatStats model.overall.ingredients
        ]
