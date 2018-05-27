module Constants exposing (init)

import Model exposing (Model)


init : ( Model, Cmd msg )
init =
    ( { message = "hello world!" }
    , Cmd.none
    )
