module DesignSystem.Typography exposing (FontSize(..), TypographyType(..), fontSize, getStylesFor, styles, typography)

import Css exposing (..)
import Css.Global as Css
import Html.Styled as Html exposing (Attribute, Html, text)
import Html.Styled.Attributes exposing (class)


type TypographyType
    = Paragraph


type FontSize
    = S
    | M
    | L
    | XL
    | XXL


fontSize : FontSize -> Style
fontSize size =
    case size of
        S ->
            Css.fontSize (rem 0.8)

        M ->
            Css.fontSize (rem 1)

        L ->
            Css.fontSize (rem 1.5)

        XL ->
            Css.fontSize (rem 2)

        XXL ->
            Css.fontSize (rem 3.5)



typography : TypographyType -> (List (Html.Attribute msg) -> List (Html msg) -> Html msg) -> List (Html.Attribute msg) -> String -> Html msg
typography typographyType tagFunction attributes content =
    let
        className =
            getClassName typographyType
    in
    tagFunction (class className :: attributes) [ text content ]


getClassName : TypographyType -> String
getClassName typographyType =
    case typographyType of
        Paragraph ->
            "title1"


getStylesFor : TypographyType -> List Style
getStylesFor typographyType =
    case typographyType of
        Paragraph ->
            [ fontSize M
            ]


styles : List Css.Snippet
styles =
    [ Paragraph ]
        |> List.map (\typographyType -> Css.class (getClassName typographyType) (getStylesFor typographyType))
