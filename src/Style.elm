module Style exposing (..)

import Html
import Html.Attributes exposing (attribute)


keyValueInput : List String
keyValueInput =
    [ "margin: auto"
    , "max-width: 40em"
    ]


pullRight : List String
pullRight =
    [ "float: right" ]


pullLeft : List String
pullLeft =
    [ "float: left" ]


keyValueInputInput : List String
keyValueInputInput =
    [ "display: inline-block", "width: 10em" ]


keyValueInputHeader : List String
keyValueInputHeader =
    [ "display: inline-block", "width: 10em" ]


autoMargin : List String
autoMargin =
    [ "margin: auto" ]


defaultText : List String
defaultText =
    [ "color: #333333" ]


emphasizedText : List String
emphasizedText =
    [ "text-size: 1.5em" ]


maxWidth : List String
maxWidth =
    [ "max-width: 60em" ]


block : List String
block =
    [ "background-color: #ffe5b7"
    , "border-radius: 0.4em"
    , "padding: 1em"
    , "margin: 1em"
    ]


blockTitle : List String
blockTitle =
    [ "text-align: center"
    , "border-bottom: solid 0.15em"
    , "padding-bottom: 1em"
    , "border-color: white"
    ]


button : List String
button =
    [ "padding: 0.3em"
    , "margin: 0.3em"
    , "border: solid thin"
    , "color: #333333"
    , "background-color: white"
    , "min-width: 2em"
    ]


buttonSelected : List String
buttonSelected =
    button ++ [ "color: white", "background-color: black" ]


displayWeight : List String
displayWeight =
    [ "min-width: 3em"
    , "display: inline-block"
    , "text-align: right"
    , "font-size: 1.5em"
    , "padding-right: 0.5em"
    ]


input : List String
input =
    [ "padding: 0.5em"
    , "margin: 0.5em"
    , "border: solid thin"
    , "color: #333333"
    ]


numberInput : List String
numberInput =
    "width: 5em" :: "text-align: right" :: input


styles : List String -> Html.Attribute a
styles ss =
    attribute "style" (List.foldr (\s0 result -> s0 ++ ";" ++ result) "" ss)
