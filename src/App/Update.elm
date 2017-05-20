module App.Update exposing (..)

import Time exposing (Time)
import RemoteData exposing (RemoteData(..))
import App.Model exposing (..)
import App.Port as Port

type Msg
  = SetQuery String
  | SignIn
  | SignOut
  | AuthChange (Maybe User)
  | SetReminders (List Reminder)
  | SetDraft (Maybe Draft)
  | ToggleRelativeDate
  | CreateReminder
  | CreateReminderSuccess Reminder
  | PeriodicTasks Time
  -- TODO: Add CreateReminderFailed

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetQuery query ->
      { model | query = query } ! [Port.parseQuery query]
    SignIn ->
      model ! [Port.signIn True]
    SignOut ->
      model ! [Port.signOut True]
    AuthChange user ->
      case user of
        Just _ ->
          { model | user = Success user, reminders = Loading } ! [Port.requestReminders True]
        Nothing ->
          { model | user = Success user } ! []
    SetReminders reminders ->
      { model | reminders = Success reminders } ! []
    SetDraft draft ->
      { model | draft = draft } ! []
    ToggleRelativeDate ->
      { model | showRelativeDate = not model.showRelativeDate } ! []
    CreateReminder ->
      case model.draft of
        Just draft ->
          model ! [Port.createReminder draft]
        Nothing ->
          model ! []
    CreateReminderSuccess reminder ->
      let
        newReminders =
          case model.reminders of
            Success reminders ->
              Success (reminders ++ [reminder])
              |> RemoteData.map (List.sortBy .startDate)
            _ ->
              Success [reminder]
      in
        { model | query = "", draft = Nothing, reminders = newReminders } ! []
    PeriodicTasks time ->
      case model.user of
        Success (Just user) ->
          model ! [Port.requestReminders True, Port.parseQuery model.query]
        _ ->
          model ! []
