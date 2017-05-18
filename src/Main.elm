import Html
import App.Model exposing (initModel)
import App.Update exposing (update)
import App.View exposing (view)

main =
  Html.beginnerProgram
    { model = initModel
    , view = view
    , update = update
    }
