module App.Update exposing (..)

import App.Model exposing (..)
import App.Port exposing (signIn, signOut)

type Msg
  = SetQuery String
  | SignIn
  | SignOut
  | AuthChange (Maybe User)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetQuery query ->
      { model | query = query } ! []
    SignIn ->
      model ! [signIn True]
    SignOut ->
      model ! [signOut True]
    AuthChange user ->
      { model | user = user } ! []
