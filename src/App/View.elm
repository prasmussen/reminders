module App.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import App.Model exposing (Model)
import App.Update exposing (Msg(..))

view : Model -> Html Msg
view model =
  div []
    [ renderNav model
    , renderContent model
    ]


renderNav model =
  nav [ class "nav has-shadow" ]
      [ div [ class "container" ]
          [ div [ class "nav-left" ]
              [ a [ class "nav-item", href "/" ]
                  [ text "Reminders" ]
              ]
          , span [ class "nav-toggle" ]
              [ span [] []
              , span [] []
              , span [] []
              ]
          , div [ class "nav-right nav-menu", id "nav-profile" ]
              [ a [ class "nav-item is-tab", id "sign-out" ]
                  [ text "Sign out (petter.rasmussen@gmail.com)" ]
              ]
          ]
      ]


renderContent model =
  div [ class "columns" ]
      [ div [ class "column is-half is-offset-one-quarter", id "content" ]
          [ Html.form [ id "reminder-form" ]
              [ div [ class "field" ]
                  [ label [ class "label" ]
                      [ text "Query" ]
                  , p [ class "control" ]
                      [ input [ attribute "autofocus" "", class "input", id "query", placeholder "Buy milk in 2 hours", attribute "required" "", type_ "text", onInput SetQuery, value model.query]
                          []
                      ]
                  , p [ class "control" ]
                      [ button [ class "button is-primary", id "create-reminder" ]
                          [ text "Create reminder" ]
                      ]
                  , p [ id "reminder-datetime" ]
                      []
                  , p [ id "reminder-relative-time" ]
                      []
                  , div [ id "reminders" ]
                      [ table [ class "table" ]
                          [ thead []
                              [ tr []
                                  [ th []
                                      [ text "Title" ]
                                  , th []
                                      [ text "When" ]
                                  ]
                              ]
                          , tbody []
                              [ tr []
                                  [ td []
                                      [ a [ href "https://www.google.com/calendar/event?eid=c3B2YjQybHRqOWRkY3NuNDNlOTU1aGV0NGsgcGV0dGVyLnJhc211c3NlbkBt" ]
                                          [ text "buy milk" ]
                                      ]
                                  , td []
                                      [ text "in an hour" ]
                                  ]
                              ]
                          ]
                      ]
                  ]
              ]
          ]
      ]
