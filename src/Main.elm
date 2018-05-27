module Main exposing (..)

import Constants
import Html
import Model exposing (..)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { init = Constants.init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
