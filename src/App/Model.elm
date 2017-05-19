module App.Model exposing (..)

type alias Model =
  { query : String
  , user : RemoteData (Maybe User)
  }

type alias User =
  { email : String
  }

type RemoteData received
  = NotAsked
  | Loading
  | RequestFailed String
  | Received received

initModel : Model
initModel =
  { query = ""
  , user = NotAsked
  }
