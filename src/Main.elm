module Main exposing (main)

import Color
import Css exposing (Style, alignItems, backgroundColor, center, color, column, displayFlex, flexDirection, height, justifyContent, maxWidth, pct, vh)
import Css.Global as Css exposing (Snippet)
import DesignSystem.Colors as Colors
import DesignSystem.Spacing exposing (SpacingSize(..), marginBottom, padding, padding2)
import DesignSystem.Typography as FontSize exposing (fontSize)
import Head
import Head.Seo as Seo
import Html
import Html.Styled exposing (Html, div, form, fromUnstyled, h1, img, input, label, main_, p, text, toUnstyled)
import Html.Styled.Attributes exposing (acceptCharset, action, class, disabled, enctype, for, id, method, name, src, tabindex, type_, value)
import Html.Styled.Events exposing (onInput, onSubmit)
import Json.Decode as Decode exposing (Decoder)
import Markdown
import Metadata exposing (Metadata)
import MySitemap
import Pages exposing (images, pages)
import Pages.Document
import Pages.ImagePath as ImagePath
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath exposing (PagePath)
import Pages.Platform exposing (Page)
import Pages.StaticHttp as StaticHttp
import Ports exposing (jsonpCallback)
import Process
import RemoteData exposing (RemoteData(..), WebData)
import Task


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.green
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "Elm France – organisation d'évènements Elm en France"
    , iarcRatingId = Nothing
    , name = "Elm France"
    , themeColor = Just Color.green
    , startUrl = pages.index
    , shortName = Just "Elm France"
    , sourceIcon = images.iconPng
    }


type alias Rendered =
    Html Msg



-- the intellij-elm plugin doesn't support type aliases for Programs so we need to use this line
-- main : Platform.Program Pages.Platform.Flags (Pages.Platform.Model Model Msg Metadata Rendered) (Pages.Platform.Msg Msg Metadata Rendered)


main : Pages.Platform.Program Model Msg Metadata Rendered
main =
    Pages.Platform.application
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = \_ -> NoOp
        , generateFiles = generateFiles
        , internals = Pages.internals
        }


generateFiles :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    ->
        List
            (Result String
                { path : List String
                , content : String
                }
            )
generateFiles siteMetadata =
    [ MySitemap.build { siteUrl = canonicalSiteUrl } siteMetadata |> Ok
    ]


markdownDocument : ( String, Pages.Document.DocumentHandler Metadata Rendered )
markdownDocument =
    Pages.Document.parser
        { extension = "md"
        , metadata = Metadata.decoder
        , body =
            \markdownBody ->
                div [] [ Markdown.toHtml [] markdownBody |> fromUnstyled ]
                    |> Ok
        }


type alias Model =
    { emailInput : String
    , mailchimpRegistration : RemoteData String ()
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" NotAsked, Cmd.none )


type Msg
    = RegisterToNewsletter
    | EmailInputChanged String
    | RegistrationDone (RemoteData String ())
    | HideRegistrationSuccessMessage
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RegisterToNewsletter ->
            ( { model | mailchimpRegistration = Loading }, subscribeToMailchimp model.emailInput )

        EmailInputChanged newValue ->
            ( { model | emailInput = newValue }, Cmd.none )

        RegistrationDone registrationResult ->
            let
                hideMessageCmd =
                    case registrationResult of
                        Success () ->
                            Process.sleep 5000
                                |> Task.attempt (always HideRegistrationSuccessMessage)

                        _ ->
                            Cmd.none
            in
            ( { model | mailchimpRegistration = registrationResult }, hideMessageCmd )

        HideRegistrationSuccessMessage ->
            let
                mailchimpRegistration =
                    case model.mailchimpRegistration of
                        Success () ->
                            NotAsked

                        _ ->
                            model.mailchimpRegistration
            in
            ( { model | mailchimpRegistration = mailchimpRegistration }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


mailchimpUrl : String
mailchimpUrl =
    "https://gmail.us3.list-manage.com/subscribe/post-json?u=9398c39f75ed42968f2d53e9c&amp;id=f4d9c246e8&c=jsonpCallback"


subscribeToMailchimp : String -> Cmd Msg
subscribeToMailchimp emailInput =
    Ports.execJsonp (mailchimpUrl ++ "&EMAIL=" ++ emailInput)


unknownError : String
unknownError =
    "Il semblerait que cela ait échoué... Réessayez dans quelques minutes ou contactez-nous sur Twitter (@ElmFrance) !"


mailchimpRegistrationResultDecoder : Decoder (RemoteData String ())
mailchimpRegistrationResultDecoder =
    Decode.field "result" Decode.string
        |> Decode.andThen
            (\type_ ->
                case type_ of
                    "error" ->
                        Decode.field "msg" Decode.string
                            |> Decode.map Failure

                    "success" ->
                        Decode.succeed (Success ())

                    _ ->
                        Decode.succeed (Failure unknownError)
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.mailchimpRegistration of
        Loading ->
            jsonpCallback
                (Decode.decodeValue mailchimpRegistrationResultDecoder
                    >> Result.withDefault (Failure unknownError)
                    >> RegistrationDone
                )

        _ ->
            Sub.none


view :
    List ( PagePath Pages.PathKey, Metadata )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    ->
        StaticHttp.Request
            { view : Model -> Rendered -> { title : String, body : Html.Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata page =
    StaticHttp.succeed
        { view =
            \model viewForPage ->
                let
                    { title, body } =
                        pageView model siteMetadata page viewForPage
                in
                { title = title
                , body =
                    body
                        |> List.singleton
                        |> main_ []
                        |> toUnstyled
                }
        , head = head page.frontmatter
        }


pageView : Model -> List ( PagePath Pages.PathKey, Metadata ) -> { path : PagePath Pages.PathKey, frontmatter : Metadata } -> Rendered -> { title : String, body : Html Msg }
pageView model siteMetadata page viewForPage =
    case page.frontmatter of
        Metadata.Index ->
            { title = "Elm France"
            , body =
                div []
                    [ Css.global indexStyles
                    , main_ [ class "home" ]
                        [ img [ class "logo", src (ImagePath.toString images.elmFranceLogo) ] []
                        , h1 [ class "title" ] [ text "Elm France" ]
                        , p [ class "subtitle" ] [ text "Vous souhaitez participer à des évènements autour du langage Elm ? Apprendre et rencontrer des personnes partageant la même passion ?" ]
                        , mailchimpForm model
                        ]
                    ]
            }


mailchimpForm : Model -> Html Msg
mailchimpForm model =
    div [ class "mailchimpForm" ]
        [ form [ id "mailchimp-form", action mailchimpUrl, acceptCharset "UTF-8", method "POST", enctype "multipart/form-data", onSubmit RegisterToNewsletter ]
            [ label [ for "mailchimp-email" ] [ text "Votre email" ]
            , input [ id "mailchimp-email", type_ "email", name "EMAIL", tabindex -1, onInput EmailInputChanged, value model.emailInput ] []
            , input [ type_ "hidden", name "b_9398c39f75ed42968f2d53e9c_f4d9c246e8", tabindex -1, value "" ] []
            , input [ type_ "submit", value "S'abonner à nos évènements", disabled (RemoteData.isLoading model.mailchimpRegistration) ] []
            ]
        , case model.mailchimpRegistration of
            Success () ->
                p [ class "success" ] [ text "Félicitation ! Vous serez tenu informé de nos prochains évènements !" ]

            Failure error ->
                p [ class "error" ] [ text error ]

            _ ->
                text ""
        ]


indexStyles : List Snippet
indexStyles =
    [ Css.class "home"
        [ height (vh 100)
        , backgroundColor Colors.elmGreen
        , color Colors.white
        , displayFlex
        , alignItems center
        , justifyContent center
        , flexDirection column
        , Css.descendants
            [ Css.class "title" [ marginBottom L, fontSize FontSize.XXL, padding2 NoSpace S ]
            , Css.class "subtitle" [ fontSize FontSize.L, padding2 NoSpace S, marginBottom L ]
            , Css.class "logo" [ maxWidth (pct 90), marginBottom L ]
            , Css.class "mailchimpForm" [ padding M, backgroundColor Colors.elmGray ]
            , Css.class "error" [ color Colors.elmOrange ]
            , Css.class "success" [ color Colors.elmBlue ]
            ]
        ]
    ]


commonHeadTags : List (Head.Tag Pages.PathKey)
commonHeadTags =
    [ Head.rssLink "/blog/feed.xml"
    , Head.sitemapLink "/sitemap.xml"
    ]


{-| <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/abouts-cards>
<https://htmlhead.dev>
<https://html.spec.whatwg.org/multipage/semantics.html#standard-metadata-names>
<https://ogp.me/>
-}
head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    commonHeadTags
        ++ (case metadata of
                Metadata.Index ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "Elm France"
                        , image =
                            { url = images.iconPng
                            , alt = "Elm France logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = "Elm France"
                        }
                        |> Seo.website
           )


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://elm-france.com"


siteTagline : String
siteTagline =
    "Organisation d'évènements autour du langage Elm"
