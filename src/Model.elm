module Model exposing (..)

import Keyboard
import Time


type alias Model =
    { message : String
    }


type Msg
    = ChangeMessage String
