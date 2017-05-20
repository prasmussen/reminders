import Html
import Time
import RemoteData exposing (RemoteData(..))
import App.Model exposing (..)
import App.Update exposing (..)
import App.View exposing (..)
import App.Port as Port

main =
  Html.program
    { init = { initModel | user = Loading } ! [Port.requestUser True]
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Port.authChange AuthChange
    , Port.draft SetDraft
    , Port.listRemindersSuccess ListRemindersSuccess
    , Port.listRemindersFailed ListRemindersFailed
    , Port.createReminderSuccess CreateReminderSuccess
    , Port.createReminderFailed CreateReminderFailed
    , Time.every (Time.minute * 1) PeriodicTasks
    ]
