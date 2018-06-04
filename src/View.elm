module View exposing (view)

import Constants
import Html exposing (Attribute, button, div, h2, h3, input, span, text)
import Html.Attributes exposing (attribute, value)
import Html.Events exposing (on, onClick, onInput, targetValue)
import Json.Decode as Json
import Model exposing (..)


type alias IngredientProperties =
    { sectionId : IngredientsSectionId
    , showMinusButton : Bool
    , index : Int
    , ingredient : Ingredient
    }


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


formatIngredient : IngredientProperties -> Html.Html Msg
formatIngredient props =
    div []
        [ textInput [ onBlur (ChangeIngredientName props.sectionId props.index) ]
            props.ingredient.name
        , textInput
            [ onBlur (ChangeIngredientPercent props.sectionId props.index) ]
            (toString props.ingredient.percent)
        , plusButton props.sectionId props.index
        , if props.showMinusButton then
            minusButton props.sectionId props.index
          else
            text ""
        ]


formatIngredients : IngredientsSectionId -> List Ingredient -> List (Html.Html Msg)
formatIngredients section ingredients =
    case ingredients of
        [] ->
            [ text "OH FUCK" ]

        [ ingredient ] ->
            [ formatIngredient
                { sectionId = section
                , showMinusButton = False
                , index = 0
                , ingredient = ingredient
                }
            ]

        _ ->
            List.indexedMap
                (\index ingredient ->
                    formatIngredient
                        { sectionId = section
                        , showMinusButton = True
                        , index = index
                        , ingredient = ingredient
                        }
                )
                ingredients


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
            [ span [] [ h3 [] [ text "Name" ] ]
            , textInput [ onBlur ChangeName ] model.name
            ]
        , div []
            [ span [] [ h3 [] [ text "Weight" ] ]
            , textInput [ onBlur ChangeWeight ] (toString model.weight)
            ]
        , div []
            [ span [] [ h3 [] [ text "Prefermented flour" ] ]
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
