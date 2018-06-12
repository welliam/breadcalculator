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


updateIngredientKind : IngredientKind -> Ingredient -> Ingredient
updateIngredientKind kind ingredient =
    { ingredient | kind = kind }


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


updateFormulaSection :
    List IngredientsSection
    -> Int
    -> (IngredientsSection -> IngredientsSection)
    -> List IngredientsSection
updateFormulaSection sections nth update =
    case ( sections, nth ) of
        ( [], _ ) ->
            []

        ( head :: rest, 0 ) ->
            update head :: rest

        ( head :: rest, n ) ->
            head :: updateFormulaSection rest n update


updateSection :
    Model
    -> IngredientsSectionId
    -> (IngredientsSection -> IngredientsSection)
    -> Model
updateSection model id update =
    case id of
        Overall ->
            { model | overall = update model.overall }

        Formula nth ->
            { model | formulas = updateFormulaSection model.formulas nth update }


updateSectionIngredient :
    Model
    -> IngredientsSectionId
    -> Int
    -> (Ingredient -> Ingredient)
    -> Model
updateSectionIngredient model id nth f =
    updateSection model
        id
        (\section -> { section | ingredients = updateNth nth section.ingredients f })


parseInputtedFloat : String -> Float -> Float
parseInputtedFloat string default =
    case ( x, String.toFloat string ) of
        ( "", _ ) ->
            0

        ( _, Ok x ) ->
            x

        ( _, Err _ ) ->
            default


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ChangeIngredientName section nth name ->
            ( updateSectionIngredient model section nth (updateIngredientName name)
            , Cmd.none
            )

        ChangeIngredientPercent section nth percent ->
            ( updateSectionIngredient model section nth (updateIngredientPercent percent)
            , Cmd.none
            )

        ChangeIngredientKind section nth kind ->
            ( updateSectionIngredient model section nth (updateIngredientKind kind)
            , Cmd.none
            )

        RemoveIngredient section nth ->
            ( updateSection model
                section
                (\section ->
                    { section
                        | ingredients = removeNth nth section.ingredients
                    }
                )
            , Cmd.none
            )

        AddIngredient section nth ->
            ( updateSection model
                section
                (\section ->
                    { section
                        | ingredients =
                            addAfter nth section.ingredients Constants.blankIngredient
                    }
                )
            , Cmd.none
            )

        ChangeWeight to ->
            ( { model | weight = parseInputtedFloat to model.weight }
            , Cmd.none
            )

        ChangePrefermentedFlour to ->
            ( { model | prefermentedFlour = parseInputtedFloat to model.weight }
            , Cmd.none
            )

        ChangeName to ->
            ( { model | name = to }
            , Cmd.none
            )
