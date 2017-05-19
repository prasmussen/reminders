module App.Update exposing (..)

import App.Model exposing (..)
import App.Port as Port

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
      model ! [Port.signIn True]
    SignOut ->
      model ! [Port.signOut True]
    AuthChange user ->
      { model | user = Received user } ! []
