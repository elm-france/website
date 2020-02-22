module Logo exposing (elmFranceLogo)

import Html.Styled exposing (Html, fromUnstyled)
import Svg exposing (Attribute, svg)
import Svg.Attributes exposing (..)


elmFranceLogo : Html msg
elmFranceLogo =
    fromUnstyled <|
        svg
            [ id "logo"
            , width "449.43"
            , height "220.42"
            , class "logo"
            ]
            [ background
            , threeCentralShapes
            , rightTriangle
            , leftTriangle
            , Svg.node "path" [ fill "#fff", d "M302.058 169.076l43.232 43.199-.028-86.431zM144.805 217.93H339.64l-97.417-97.416z" ] []
            , leftCharacter
            , rightCharacter
            ]


background : Svg.Svg msg
background =
    Svg.node "path" [ id "background", fill "#1293d8", d "M-.408-.408h452.33v223.51H-.408z" ] []


threeCentralShapes : Svg.Svg msg
threeCentralShapes =
    Svg.node "g" [ id "three-center-shapes", fill "#fff" ] [ Svg.node "path" [ d "M286.768 64.655h-89.094l44.549 44.547zM287.214 56.658l-44.87-44.873h-97.54l44.872 44.873zM296.645 66.086l48.548 48.548-48.769 48.77-48.548-48.549z" ] [] ]


rightTriangle : Svg.Svg msg
rightTriangle =
    Svg.node "g" [ id "right-triangle", fill "#fff" ] [ Svg.node "path" [ d "M347.16 100.982l14.493-90.487L271.159 -4z" ] [] ]


leftTriangle : Svg.Svg msg
leftTriangle =
    Svg.node "g" [] [ Svg.node "path" [ id "left-triangle", fill "#fff", d "M100 217.93L100 12L200 115z" ] [] ]


leftCharacter : Svg.Svg msg
leftCharacter =
    Svg.node "g"
        [ id "left-character", fill characterColor, strokeWidth ".423" ]
        [ Svg.node "path" [ d "M37.59 96.58c7.475 1.304 14.619-3.698 15.926-11.197 1.306-7.49-3.707-14.62-11.197-15.926-7.49-1.306-14.62 3.707-15.926 11.197-1.306 7.49 3.707 14.62 11.197 15.926z" ] []
        , Svg.node "path" [ d "M81.5 73c-2.077-.065-3.152.84-4.366 2.575L63.86 94.533l-18.997 8.68s-19.446-3.614-21.13-3.664c-1.732-.052-3.525.17-4.96 1.365-17.277 70.222-2.493-2.838-18.71 111.31a7.265 7.265 0 0 0 14.409 1.864l7.412-57.324 1.672.291 19.826 20.898-4.993 34.152a7.264 7.264 0 0 0 6.138 8.239 7.264 7.264 0 0 0 8.24-6.137l5.503-37.643a7.264 7.264 0 0 0-1.919-6.051l-13.697-14.437 7.226-41.436 20.69-9.459a6.302 6.302 0 0 0 2.536-2.098l13.026-18.856c-.466-1.785-4.03-9.904-4.631-11.222z" ] []
        ]


rightCharacter : Svg.Svg msg
rightCharacter =
    Svg.node "g"
        [ id "right-character", fill characterColor ]
        [ Svg.node "path" [ d "M411.84 93.658c-7.476 1.304-14.619-3.698-15.926-11.197-1.306-7.49 3.707-14.62 11.197-15.926 7.49-1.306 14.62 3.707 15.926 11.197 1.306 7.49-3.707 14.62-11.197 15.926z" ] []
        , Svg.node "path" [ d "M367.73 70.013c2.077-.065 3.355.903 4.569 2.638l13.275 18.958 18.997 8.68s19.446-3.614 21.13-3.664c1.732-.052 3.525.169 4.96 1.365 17.277 70.222 2.493-2.839 18.71 111.31a7.265 7.265 0 0 1-14.409 1.863l-7.412-57.324-1.672.292-19.826 20.898 4.992 34.152a7.264 7.264 0 0 1-6.137 8.238 7.264 7.264 0 0 1-8.24-6.137l-5.503-37.643a7.265 7.265 0 0 1 1.918-6.05l13.697-14.438c-.842-4.83-6.488-37.21-7.226-41.436l-20.69-9.458a6.301 6.301 0 0 1-2.535-2.098l-10.635-17.294c.326-1.942 1.795-11.388 2.038-12.847z" ] []
        , Svg.node "ellipse"
            [ transform "matrix(.87381 -.48626 .52178 .85308 0 0)"
            , cx "321.03"
            , cy "268.96"
            , rx "2.568"
            , ry "5.649"
            ]
            []
        , Svg.node "path" [ d "M419.1 73.373c9.458-18.827 11.458-4.066 12.519-.795 1.68 5.215 4.729 5.966 4.729 5.966s-1.459 1.768-4.11-.442-4.23-4.457-4.761-6.578c-.53-2.121-4.758 4.889-4.758 4.889z", stroke characterColor ] []
        ]


characterColor =
    "#67eaff"
