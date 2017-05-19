port module App.Port exposing (..)

import App.Model exposing (..)

port authChange : (Maybe User -> msg) -> Sub msg

port requestUser : Bool -> Cmd msg
port signIn : Bool -> Cmd msg
port signOut : Bool -> Cmd msg
