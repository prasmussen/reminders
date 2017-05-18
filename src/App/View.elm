module App.View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import App.Model exposing (Model)
import App.Update exposing (Msg)

view : Model -> Html Msg
view model =
  div [] [ text "hello!"]
