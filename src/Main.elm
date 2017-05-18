import Html
import App.Model exposing (..)
import App.Update exposing (..)
import App.View exposing (..)
import App.Port as Port

main =
  Html.program
    { init = (initModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Port.authChange AuthChange
    ]
