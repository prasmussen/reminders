module App.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import App.Model exposing (..)
import App.Update exposing (Msg(..))

view : Model -> Html Msg
view model =
  div []
    [ renderNav model
    , renderContent model
    ]


renderNav model =
  let
    authLink =
      case model.user of
        Received (Just user) ->
          a [ class "nav-item is-tab", onClick SignOut ] [ text <| "Sign out (" ++ user.email ++ ")" ]
        Received Nothing ->
          a [ class "nav-item is-tab", onClick SignIn ] [ text "Sign in" ]
        _ ->
          span [] []
  in
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
            , div [ class "nav-right nav-menu" ]
                [ authLink
                ]
            ]
        ]


renderContent model =
  let
    content =
      case model.user of
        NotAsked ->
          [ renderSection "" <| p [ class "container has-text-centered" ] [ text "Initializing..." ] ]
        Loading ->
          [ renderSection "" <| p [ class "container has-text-centered" ] [ text "Loading..." ] ]
        RequestFailed msg ->
          [ renderSection "" <| p [ class "container has-text-centered" ] [ text msg ] ]
        Received (Just user) ->
          authUserContent model
        Received Nothing ->
          anonUserContent
  in
    div [] content


anonUserContent =
  let
    content = 
      p [] [ text "After signing in with your google account you will be able to easily create reminders in you google calendar by entering text into a text field. The title and time is extracted from the text using a natural language date parser. You will also see a list of all upcoming reminders." ]
  in
    [ renderSection "Welcome to Reminders" content ]

authUserContent model =
  [ renderSection "New reminder" (renderCompose model)
  , hr [ class "is-marginless"] []
  , renderSection "Upcoming reminders" (renderReminders model)
  ]

renderCompose model =
  Html.form []
    [ div [ class "field" ]
        [ label [ class "label" ]
            [ text "Query" ]
        , p [ class "control" ]
            [ input [ attribute "autofocus" "", class "input is-large", placeholder "buy milk tomorrow 18:00", attribute "required" "", type_ "text", onInput SetQuery, value model.query] []
            ]
        , p [ id "reminder-datetime" ] []
        , p [ id "reminder-relative-time" ] []
        , renderDraft model
        ]
    ]

renderReminders model =
  case model.reminders of
    NotAsked ->
      p [] []
    Loading ->
      p [ class "has-text-centered" ] [ text "Loading reminders..." ]
    RequestFailed msg ->
      p [ class "has-text-centered" ] [ text msg ]
    Received [] ->
      p [ class "has-text-centered" ] [ text "No upcoming reminders" ]
    Received reminders ->
      let
        reminderTr reminder =
          tr []
            [ td [] [ a [ href reminder.link ] [ text reminder.title ] ]
            , td [] [ text reminder.startRelative ]
            ]
      in
        div [ id "reminders" ]
          [ table [ class "table" ]
              [ thead []
                  [ tr []
                      [ th [] [ text "Title" ]
                      , th [] [ text "When" ]
                      ]
                  ]
              , tbody [] (List.map reminderTr reminders)
              ]
          ]

renderDraft model =
  case model.draft of
    Nothing ->
      div [ id "draft" ] []
    Just draft ->
      div [ class "card", id "draft" ]
          [ div [ class "card-content" ]
              [ div [ class "content" ]
                  [ text draft.title
                  , br [] []
                  , small [] [ text draft.start ]
                  ]
              ]
          , footer [ class "card-footer" ]
              [ a [ class "card-footer-item" ]
                  [ text "Save reminder" ]
              ]
          ]

renderSection title content =
  section [ class "section" ]
      [ div [ class "container" ]
          [ div [ class "heading" ]
              [ h1 [ class "title" ] [ text title ]
              ]
          , content
          ]
      ]
