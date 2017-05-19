module App.Update exposing (..)

import App.Model exposing (..)
import App.Port as Port

type Msg
  = SetQuery String
  | SignIn
  | SignOut
  | AuthChange (Maybe User)
  | SetReminders (List Reminder)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetQuery query ->
      { model | query = query } ! []
    SignIn ->
      model ! [Port.signIn True]
    SignOut ->
      model ! [Port.signOut True]
    AuthChange user ->
      case user of
        Just _ ->
          { model | user = Received user, reminders = Loading } ! [Port.requestReminders True]
        Nothing ->
          { model | user = Received user } ! []
    SetReminders reminders ->
      { model | reminders = Received reminders } ! []
