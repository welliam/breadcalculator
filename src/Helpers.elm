module Helpers exposing (mapWithIndex)


mapWithIndex : (a -> Int -> b) -> List a -> List b
mapWithIndex =
    let
        go index f list =
            case list of
                [] ->
                    []

                head :: rest ->
                    f head index :: go (index + 1) f rest
    in
    go 0
