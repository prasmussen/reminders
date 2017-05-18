port module App.Port exposing (..)

import App.Model exposing (..)

port authChange : (Maybe User -> msg) -> Sub msg
