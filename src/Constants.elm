module Constants exposing (init)

import Model exposing (Model)


init : ( Model, Cmd msg )
init =
    ( { ingredients = [ { name = "hello", percent = 100 } ] }
    , Cmd.none
    )
