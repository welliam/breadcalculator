module Model exposing (..)


type alias MetaModel a =
    { overall : MetaIngredientsSection a
    , formulas : List IngredientsSection
    , name : String
    , weight : Float
    , prefermentedFlour : Float
    }


type alias MetaIngredientsSection a =
    { name : String
    , ingredients : List a
    }


type alias IngredientsSection =
    MetaIngredientsSection Ingredient


type alias WeightedIngredientsSection =
    MetaIngredientsSection WeightedIngredient


type alias Ingredient =
    { name : String
    , percent : Float
    , kind : IngredientKind
    }


type alias WeightedIngredient =
    { name : String
    , percent : Float
    , kind : IngredientKind
    , weight : Float
    }


type alias Model =
    MetaModel Ingredient


type alias ProcessedModel =
    MetaModel WeightedIngredient


type IngredientKind
    = Flour
    | Water
    | Other



--------------------


type IngredientsSectionId
    = Overall
    | Formula Int


type Msg
    = ChangeIngredientName IngredientsSectionId Int String
    | ChangeIngredientPercent IngredientsSectionId Int String
    | ChangeIngredientKind IngredientsSectionId Int IngredientKind
    | RemoveIngredient IngredientsSectionId Int
    | AddIngredient IngredientsSectionId Int
    | ChangeName String
    | ChangeWeight String
    | ChangePrefermentedFlour String
