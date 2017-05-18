module App.Model exposing (..)

type alias Model =
  { query : String
  , user : Maybe User
  }

type alias User =
  { email : String
  }

initModel : Model
initModel =
  { query = ""
  , user = Nothing
  }
