module View exposing (view)

import Constants
import Html exposing (Attribute, button, div, h2, h3, input, label, span, text)
import Html.Attributes exposing (attribute, checked, value)
import Html.Events exposing (on, onClick, onInput, targetValue)
import Json.Decode as Json
import Model exposing (..)
import String


type alias IngredientProperties =
    { sectionId : IngredientsSectionId
    , showMinusButton : Bool
    , index : Int
    , ingredient : Ingredient
    , onePercentWeight : Float
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


consIf : Bool -> a -> List a -> List a
consIf b x t =
    if b then
        x :: t
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
                (consIf
                    (kind == k)
                    (attribute "style" "color: white; background-color: black")
                    [ attribute "type" "button"
                    , onClick (ChangeIngredientKind section nth k)
                    ]
                )
                [ text (ingredientKindLabel k) ]
    in
    span [] (List.map fmt [ Model.Flour, Model.Water, Model.Other ])


displayFloat : Float -> String
displayFloat float =
    toString (round float) ++ "g"


formatIngredient : IngredientProperties -> Html.Html Msg
formatIngredient props =
    div []
        [ textInput [ onBlur (ChangeIngredientName props.sectionId props.index) ]
            props.ingredient.name
        , textInput
            [ onBlur (ChangeIngredientPercent props.sectionId props.index) ]
            (toString props.ingredient.percent)
        , span
            [ attribute "style" "min-width: 3em; display: inline-block; text-align: right" ]
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
    div
        []
        [ h2 [] [ text section.name ]
        , div [] (formatIngredients weight sectionId section.ingredients)
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


computeOnePercentWeight : Model -> Float
computeOnePercentWeight m =
    m.weight / List.sum (List.map .percent m.overall.ingredients)


view : Model -> Html.Html Msg
view model =
    let
        onePercentWeight =
            computeOnePercentWeight model
    in
    div []
        [ statsSection model
        , formatIngredientsSection onePercentWeight Overall model.overall
        , div []
            (List.indexedMap
                (\nth section ->
                    formatIngredientsSection onePercentWeight (Formula nth) section
                )
                model.formulas
            )
        , formatStats model.overall.ingredients
        ]
