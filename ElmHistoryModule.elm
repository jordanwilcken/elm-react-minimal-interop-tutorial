port module ElmHistoryModule exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


port gamestates : (Gamestate -> msg) -> Sub msg


port setGamestate : Gamestate -> Cmd msg


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { history : List Entry
    }


type alias Entry =
    List (Maybe String)


init : ( Model, Cmd Msg )
init =
    ( Model [ firstEntry ], Cmd.none )


firstEntry: Entry
firstEntry =
    List.repeat 9 Nothing


type alias Gamestate =
    { stepNumber : Int
    , squares : Entry
    }


type Msg
    = GamestateReceived Gamestate
    | EntryClicked Int Entry


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GamestateReceived gamestate ->
            let
                newHistory =
                    model.history
                        |> List.indexedMap (\index entryItem -> Gamestate index entryItem)
                        |> List.filter (\stateItem -> stateItem.stepNumber < gamestate.stepNumber)
                        |> (\filtered -> List.append filtered [ gamestate ])
                        |> List.map (\stateItem -> stateItem.squares)
            in
            ( { model | history = Debug.log "new history is: " newHistory }, Cmd.none )

        EntryClicked stepNumber entry ->
            ( model, setGamestate <| Gamestate stepNumber entry )


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    gamestates GamestateReceived



-- VIEW


view : Model -> Html Msg
view model =
    let
        toHistoryButton index entry =
            let
                theText =
                    if index == 0 then
                        "Go to game start"

                    else
                        "Go to move#" ++ (index |> toString)
            in
            li []
                [ button
                    [ onClick (EntryClicked index entry) ]
                    [ text theText ]
                ]

        historyButtons =
            List.indexedMap toHistoryButton model.history
    in
    ol [] historyButtons


viewMessage : String -> Html msg
viewMessage msg =
    div [] [ text msg ]
