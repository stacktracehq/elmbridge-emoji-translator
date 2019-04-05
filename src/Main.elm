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
    , currentKey : String
    }


init : Model
init =
    { currentText = ""
    , direction = TextToEmoji
    , currentKey = defaultKey
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
        SetSelectedKey key ->
            { model | currentKey = key }



-- VIEW

defaultKey = "😡"

translateText model =
    case model.direction of
        TextToEmoji ->
            EmojiConverter.textToEmoji model.currentKey model.currentText
        EmojiToText ->
            EmojiConverter.emojiToText model.currentKey model.currentText

renderKey currentKey x = 
    Html.div 
        [ Html.Attributes.class "col s2 m1 emoji-size"
        , Html.Events.onClick (SetSelectedKey x)
        ]
        [ Html.div 
            [ Html.Attributes.classList
                [ ( "key-selector", True )
                , ( "is-selected", x == currentKey )
                ]
            ]
            [ Html.text x ]
        ] 

renderKeys currentKey =
    Html.div
        [ Html.Attributes.class "row" ]
        (List.map (\emoji -> renderKey currentKey emoji) EmojiConverter.supportedEmojis)

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
        , Html.section [ Html.Attributes.class "container" ]
            [ Html.h4 [ Html.Attributes.class "center" ]
                [ Html.text "Select Your Key" ]
            , renderKeys model.currentKey
            ]
        ]
        
