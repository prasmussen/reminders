module App.Model exposing (..)

type alias Model =
  { query : String
  }

initModel : Model
initModel =
  { query = ""
  }
