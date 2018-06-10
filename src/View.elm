module View exposing (view)

import Constants
import Html exposing (Attribute, button, div, h2, h3, input, label, span, text)
import Html.Attributes exposing (attribute, checked, value)
import Html.Events exposing (on, onClick, onInput, targetValue)
import Json.Decode as Json
import Model exposing (..)
import String
import Style


type alias IngredientProperties =
    { sectionId : IngredientsSectionId
    , showMinusButton : Bool
    , index : Int
    , ingredient : Ingredient
    , onePercentWeight : Float
    }


block : String -> List (Html.Html Msg) -> Html.Html Msg
block title body =
    div [ Style.styles Style.block ]
        (h2 [ Style.styles Style.blockTitle ] [ text title ] :: body)


keyValueInput : String -> Html.Html Msg -> Html.Html Msg
keyValueInput key input =
    div [ Style.styles Style.keyValueInput ]
        [ h2 [ Style.styles Style.keyValueInputHeader ] [ text key ]
        , input
        ]


textInput : List (Attribute Msg) -> String -> Html.Html Msg
textInput attributes inputValue =
    input
        (attribute "type" "text" :: value inputValue :: attributes)
        []


minusButton : IngredientsSectionId -> Int -> Html.Html Msg
minusButton section i =
    button [ onClick (RemoveIngredient section i), Style.styles Style.button ] [ text "-" ]


plusButton : IngredientsSectionId -> Int -> Html.Html Msg
plusButton section i =
    button [ onClick (AddIngredient section i), Style.styles Style.button ] [ text "+" ]


onBlur : (String -> Msg) -> Attribute Msg
onBlur tagger =
    on "blur" (Json.map tagger targetValue)


appendIf : Bool -> List a -> List a -> List a
appendIf b maybeAppend t =
    if b then
        maybeAppend ++ t
    else
        t


ingredientKindLabel : IngredientKind -> String
ingredientKindLabel kind =
    case kind of
        Model.Flour ->
            "Flour"

        Model.Water ->
            "Water"

        Model.Other ->
            "Other"


ingredientKindSelector : IngredientsSectionId -> Int -> IngredientKind -> Html.Html Msg
ingredientKindSelector section nth kind =
    let
        fmt k =
            button
                [ Style.styles
                    (if kind == k then
                        Style.buttonSelected
                     else
                        Style.button
                    )
                , attribute "type" "button"
                , onClick (ChangeIngredientKind section nth k)
                ]
                [ text (ingredientKindLabel k) ]
    in
    span [] (List.map fmt [ Model.Flour, Model.Water, Model.Other ])


displayFloat : Float -> String
displayFloat float =
    toString (round float) ++ "g"


formatIngredient : IngredientProperties -> Html.Html Msg
formatIngredient props =
    div []
        [ textInput
            [ Style.styles Style.input
            , onBlur (ChangeIngredientName props.sectionId props.index)
            ]
            props.ingredient.name
        , textInput
            [ Style.styles Style.numberInput
            , onBlur (ChangeIngredientPercent props.sectionId props.index)
            ]
            (toString props.ingredient.percent)
        , span
            [ Style.styles Style.displayWeight ]
            [ text (displayFloat (props.onePercentWeight * props.ingredient.percent)) ]
        , ingredientKindSelector props.sectionId props.index props.ingredient.kind
        , plusButton props.sectionId props.index
        , if props.showMinusButton then
            minusButton props.sectionId props.index
          else
            text ""
        ]


formatIngredients : Float -> IngredientsSectionId -> List Ingredient -> List (Html.Html Msg)
formatIngredients onePercentWeight section ingredients =
    case ingredients of
        [] ->
            [ text "OH FUCK" ]

        [ ingredient ] ->
            [ formatIngredient
                { sectionId = section
                , showMinusButton = False
                , index = 0
                , ingredient = ingredient
                , onePercentWeight = onePercentWeight
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
                        , onePercentWeight = onePercentWeight
                        }
                )
                ingredients


formatIngredientsSection :
    Float
    -> IngredientsSectionId
    -> IngredientsSection
    -> Html.Html Msg
formatIngredientsSection weight sectionId section =
    block section.name
        [ div [] (formatIngredients weight sectionId section.ingredients) ]


statsSection : Model -> Html.Html Msg
statsSection model =
    block "Build-a-bread workshop"
        [ keyValueInput "Name"
            (textInput [ Style.styles Style.input, onBlur ChangeName ]
                model.name
            )
        , keyValueInput "Weight"
            (textInput [ Style.styles Style.numberInput, onBlur ChangeWeight ]
                (toString model.weight)
            )
        , keyValueInput "Prefermented flour"
            (textInput [ Style.styles Style.numberInput, onBlur ChangePrefermentedFlour ]
                (toString model.prefermentedFlour)
            )
        ]


computeOnePercentWeight : Model -> Float
computeOnePercentWeight m =
    m.weight / List.sum (List.map .percent m.overall.ingredients)


view : Model -> Html.Html Msg
view model =
    let
        onePercentWeight =
            computeOnePercentWeight model
    in
    div [ Style.styles (Style.autoMargin ++ Style.maxWidth ++ Style.defaultText) ]
        [ statsSection model
        , formatIngredientsSection onePercentWeight Overall model.overall
        , div []
            (List.indexedMap
                (\nth section ->
                    formatIngredientsSection onePercentWeight (Formula nth) section
                )
                model.formulas
            )
        ]
