module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html
import Html.Attributes
import Html.Events
import EmojiConverter



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL

type Direction = TextToEmoji
               | EmojiToText


type alias Model =
    { currentText : String
    , direction : Direction
    }


init : Model
init =
    { currentText = ""
    , direction = TextToEmoji
    }



-- UPDATE


type Msg
    = SetCurrentText String
    | ToggleDirection


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetCurrentText newText ->
            -- currently, this does nothing!
            { model | currentText = newText }
        ToggleDirection ->
            let 
                newDirection = 
                    case model.direction of
                        TextToEmoji ->
                            EmojiToText
                        EmojiToText ->
                            TextToEmoji
            in
            { model | direction = newDirection }



-- VIEW

defaultKey = "key"

translateText model =
    case model.direction of
        TextToEmoji ->
            EmojiConverter.textToEmoji defaultKey model.currentText
        EmojiToText ->
            EmojiConverter.emojiToText defaultKey model.currentText


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
            [
                Html.label 
                    []
                    [ Html.text "Translate text"
                    , Html.input
                        [ Html.Attributes.type_ "checkbox"
                        , Html.Events.onClick ToggleDirection
                        ]
                        []
                    , Html.span
                        [ Html.Attributes.class "lever" ]
                        []
                    , Html.text "Translate Emoji"
                    ]
            ]
        , Html.p
            [ Html.Attributes.class "center output-text emoji-size" ]
            [ Html.text (translateText model) ]
        ]
