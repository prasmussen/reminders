module App.Model exposing (..)

import RemoteData exposing (RemoteData(..))

type alias Model =
  { query : String
  , user : RemoteData String (Maybe User)
  , reminders : RemoteData String (List Reminder)
  , draft : Maybe Draft
  , showRelativeDate : Bool
  , showRightMenuOnMobile : Bool
  }

type alias User =
  { email : String
  }

type alias Draft =
  { title : String
  , startDate : String
  , endDate : String
  , start : String
  , end : String
  }

type alias Reminder =
  { title : String
  , link : String
  , startDate : String
  , start : String
  , startRelative : String
  }

initModel : Model
initModel =
  { query = ""
  , user = NotAsked
  , reminders = NotAsked
  , draft = Nothing
  , showRelativeDate = True
  , showRightMenuOnMobile = False
  }
