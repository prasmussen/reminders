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
  | ListRemindersSuccess (List Reminder)
  | ListRemindersFailed String
  | SetDraft (Maybe Draft)
  | ToggleRelativeDate
  | ToggleRightMenuOnMobile
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
      { model | showRightMenuOnMobile = False } ! [Port.signIn True]
    SignOut ->
      { model | showRightMenuOnMobile = False } ! [Port.signOut True]
    AuthChange user ->
      case user of
        Just _ ->
          { model | user = Success user, reminders = Loading } ! [Port.listReminders True]
        Nothing ->
          { model | user = Success user } ! []
    ListRemindersSuccess reminders ->
      { model | reminders = Success reminders } ! []
    ListRemindersFailed error ->
      { model | reminders = Failure error } ! []
    SetDraft draft ->
      { model | draft = draft } ! []
    ToggleRelativeDate ->
      { model | showRelativeDate = not model.showRelativeDate } ! []
    ToggleRightMenuOnMobile ->
      { model | showRightMenuOnMobile = not model.showRightMenuOnMobile } ! []
    CreateReminder ->
      case (Maybe.map validateDraft model.draft) of
        Just (Ok draft) ->
          model ! [Port.createReminder draft]
        _ ->
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
          model ! [Port.listReminders True, Port.parseQuery model.query]
        _ ->
          model ! []
