port module Ports exposing (execJsonp, jsonpCallback)

import Json.Decode as Decode


port execJsonp : String -> Cmd msg


port jsonpCallback : (Decode.Value -> msg) -> Sub msg
