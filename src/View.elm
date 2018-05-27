module View exposing (view)

import Constants
import Html exposing (text)
import Model exposing (Model)


view : Model -> Html.Html msg
view model =
    text model.message
