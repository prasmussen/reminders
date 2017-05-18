module App.Update exposing (..)

import App.Model exposing (..)

type Msg
  = SetQuery String
  | AuthChange (Maybe User)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetQuery query ->
      { model | query = query } ! []
    AuthChange user ->
      { model | user = user } ! []
