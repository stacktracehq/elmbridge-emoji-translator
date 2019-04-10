module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import EmojiConverter exposing (textToEmoji)
import Html
import Html.Attributes
import Html.Events



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type Direction
    = TextToEmoji
    | EmojiToText


type alias Model =
    { currentText : String
    , direction : Direction
    , selectedKey : String
    }


init : Model
init =
    { currentText = ""
    , direction = TextToEmoji
    , selectedKey = defaultKey
    }



-- UPDATE


type Msg
    = SetCurrentText String
    | ToggleDirection
    | SetSelectedKey String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetCurrentText newText ->
            { model | currentText = newText }

        ToggleDirection ->
            case model.direction of
                TextToEmoji ->
                    { model | direction = EmojiToText }

                EmojiToText ->
                    { model | direction = TextToEmoji }

        SetSelectedKey emoji ->
            { model | selectedKey = emoji }



-- VIEW


defaultKey : String
defaultKey =
    "😅"


translateText : Model -> String
translateText model =
    case model.direction of
        TextToEmoji ->
            EmojiConverter.textToEmoji model.selectedKey model.currentText

        EmojiToText ->
            EmojiConverter.emojiToText model.selectedKey model.currentText


renderKey : Model -> String -> Html.Html Msg
renderKey model emoji =
    Html.div
        [ Html.Attributes.class "col s2 m1 emoji-size" ]
        [ Html.div
            [ Html.Attributes.classList
                [ ( "key-selector", True )
                , ( "is-selected", emoji == model.selectedKey )
                ]
            , Html.Events.onClick (SetSelectedKey emoji)
            ]
            [ Html.text emoji ]
        ]


renderKeys : Model -> Html.Html Msg
renderKeys model =
    Html.div
        [ Html.Attributes.class "row" ]
        (List.map
            (\emoji -> renderKey model emoji)
            EmojiConverter.supportedEmojis
        )


view : Model -> Html.Html Msg
view model =
    Html.div
        []
        [ Html.node "link"
            [ Html.Attributes.rel "stylesheet"
            , Html.Attributes.href "stylesheets/main.css"
            ]
            []
        , Html.nav
            []
            [ Html.div
                [ Html.Attributes.class "nav-wrapper light-blue lighten-2" ]
                [ Html.div
                    [ Html.Attributes.class "brand-logo center" ]
                    [ Html.text "Elmoji Translator" ]
                ]
            ]
        , Html.section
            [ Html.Attributes.class "container" ]
            [ Html.div
                [ Html.Attributes.class "input-field" ]
                [ Html.input
                    [ Html.Attributes.type_ "text"
                    , Html.Attributes.class "center"
                    , Html.Attributes.placeholder "Let's Translate!"
                    , Html.Events.onInput SetCurrentText
                    ]
                    []
                ]
            ]
        , Html.div
            [ Html.Attributes.class "switch center" ]
            [ Html.label []
                [ Html.text "Translate Text"
                , Html.input [ Html.Attributes.type_ "checkbox" ] []
                , Html.span [ Html.Attributes.class "lever", Html.Events.onClick ToggleDirection ] []
                , Html.text "Translate Emoji"
                ]
            ]
        , Html.div
            [ Html.Attributes.class "divider" ]
            []
        , Html.section
            [ Html.Attributes.class "container" ]
            [ Html.h4 [ Html.Attributes.class "center" ] []
            , renderKeys model
            ]
        , Html.p
            [ Html.Attributes.class "center output-text emoji-size" ]
            [ Html.text (translateText model) ]
        ]
