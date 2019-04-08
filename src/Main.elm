module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import EmojiConverter
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


type alias Model =
    { currentText : String
    , defaultKey : String
    }


init : Model
init =
    { currentText = ""
    , defaultKey = "😎"
    }



-- UPDATE


type Msg
    = SetCurrentText String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetCurrentText newText ->
            { model | currentText = newText }



-- HELPERS


translateCurrentText model =
    EmojiConverter.textToEmoji model.defaultKey model.currentText



-- VIEW


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
                , Html.p
                    [ Html.Attributes.class "center output-text emoji-size" ]
                    [ Html.text (translateCurrentText model) ]
                ]
            ]
        ]
