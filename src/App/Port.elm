port module App.Port exposing (..)

import App.Model exposing (..)

-- Incoming ports
port authChange : (Maybe User -> msg) -> Sub msg
port reminders : (List Reminder -> msg) -> Sub msg

-- Outgoing ports
port requestUser : Bool -> Cmd msg
port requestReminders : Bool -> Cmd msg
port signIn : Bool -> Cmd msg
port signOut : Bool -> Cmd msg
