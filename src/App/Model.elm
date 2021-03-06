module App.Model exposing (..)

import RemoteData exposing (RemoteData(..))


type alias Model =
    { query : String
    , user : RemoteData String (Maybe User)
    , reminders : RemoteData String (List Reminder)
    , draft : Maybe Draft
    , createReminderError : Maybe String
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
    , staleStartDate : Bool
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
    , createReminderError = Nothing
    , showRelativeDate = True
    , showRightMenuOnMobile = False
    }


validateDraft : Draft -> Result String Draft
validateDraft draft =
    case draft.staleStartDate of
        True ->
            Err "Reminder must be in the future"

        False ->
            Ok draft
