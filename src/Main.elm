module Main exposing (..)

import App.Model exposing (..)
import App.Port as Port
import App.Update exposing (..)
import App.View exposing (..)
import Html
import RemoteData exposing (RemoteData(..))
import Time


main =
    Html.program
        { init = { initModel | user = Loading } ! [ Port.getUser True ]
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Port.getUserSuccess GetUserSuccess
        , Port.getUserFailed GetUserFailed
        , Port.listRemindersSuccess ListRemindersSuccess
        , Port.listRemindersFailed ListRemindersFailed
        , Port.createReminderSuccess CreateReminderSuccess
        , Port.createReminderFailed CreateReminderFailed
        , Port.draft SetDraft
        , Time.every (Time.minute * 1) PeriodicTasks
        ]
