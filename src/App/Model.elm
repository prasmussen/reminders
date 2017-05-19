module App.Model exposing (..)

type alias Model =
  { query : String
  , user : RemoteData (Maybe User)
  , reminders : RemoteData (List Reminder)
  , draft : Maybe Draft
  }

type alias User =
  { email : String
  }

type alias Draft =
  { title : String
  , start : String
  , end : String
  }

type alias Reminder =
  { title : String
  , link : String
  , start : String
  , startRelative : String
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
  , reminders = NotAsked
  , draft = Nothing
  }
