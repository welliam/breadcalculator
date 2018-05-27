module Update exposing (update)

import Constants
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    ( model, Cmd.none )
