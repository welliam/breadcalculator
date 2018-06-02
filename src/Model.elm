module Model exposing (..)


type alias Model =
    { overall : IngredientsSection
    , formulas : List IngredientsSection
    , name : String
    , weight : Float
    , prefermentedFlour : Float
    }


type alias IngredientsSection =
    { name : String
    , ingredients : List Ingredient
    }


type alias Ingredient =
    { name : String
    , percent : Float
    }



--------------------


type IngredientsSectionId
    = Overall
    | Formula Int


type Msg
    = ChangeIngredientName IngredientsSectionId Int String
    | ChangeIngredientPercent IngredientsSectionId Int String
    | RemoveIngredient IngredientsSectionId Int
    | AddIngredient IngredientsSectionId Int
    | ChangeName String
    | ChangeWeight String
    | ChangePrefermentedFlour String



--------------------


type IngredientKind
    = Flour
    | Water
    | Other
