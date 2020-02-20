module Metadata exposing (ArticleMetadata, Metadata(..), PageMetadata, decoder)

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)
import Pages
import Pages.ImagePath exposing (ImagePath)


type Metadata
    = Index


type alias ArticleMetadata =
    { title : String
    , description : String
    , published : Date
    , image : ImagePath Pages.PathKey
    , draft : Bool
    }


type alias PageMetadata =
    { title : String }


decoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\pageType ->
                case pageType of
                    "index" ->
                        Decode.succeed Index

                    _ ->
                        Decode.fail <| "Unexpected page type " ++ pageType
            )
