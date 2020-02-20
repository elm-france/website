module DesignSystem.Stylesheet exposing (..)

import Css.Global exposing (global)
import DesignSystem.Typography as Typography
import Html.Styled


stylesheet : Html.Styled.Html msg
stylesheet =
    global
        Typography.styles
