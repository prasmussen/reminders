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
    , Port.reminders SetReminders
    , Port.draft SetDraft
    , Port.createReminderSuccess CreateReminderSuccess
    , Time.every (Time.minute * 1) RequestReminders
    , Time.every (Time.minute * 1) ParseQuery
    ]
