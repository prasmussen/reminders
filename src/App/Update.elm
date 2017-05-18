module App.Update exposing (..)

import App.Model exposing (Model)

type Msg
  = SetQuery String

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetQuery query ->
      {model | query = query}
