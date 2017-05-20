module App.View exposing (..)

import RemoteData exposing (RemoteData(..))
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
        Success (Just user) ->
          a [ class "nav-item is-tab", onClick SignOut ] [ text <| "Sign out (" ++ user.email ++ ")" ]
        Success Nothing ->
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
        Failure msg ->
          [ renderSection "" <| p [ class "container has-text-centered" ] [ text msg ] ]
        Success (Just user) ->
          authUserContent model
        Success Nothing ->
          anonUserContent
  in
    div [] content


anonUserContent =
  let
    content = 
      p [] [ text "After signing in with your google account you will be able to easily create reminders in you google calendar by entering text into a text field. The title and time is extracted from the text using a natural language date parser. You will receive an email at the time of the reminder. A list of upcoming reminders is also shown." ]
  in
    [ renderSection "Welcome to Reminders" content ]

authUserContent model =
  [ renderSection "New reminder" (renderCompose model)
  , hr [ class "is-marginless"] []
  , renderSection "Upcoming reminders" (renderReminders model)
  ]

renderCompose model =
  Html.form [ onSubmit CreateReminder ]
    [ div [ class "field" ]
        [ p [ class "control" ]
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
    Failure msg ->
      p [ class "has-text-centered" ] [ text msg ]
    Success [] ->
      p [ class "has-text-centered" ] [ text "No upcoming reminders" ]
    Success reminders ->
      let
        when reminder =
          if model.showRelativeDate then
             reminder.startRelative
          else
            reminder.start
        reminderTr reminder =
          tr []
            [ td [] [ a [ href reminder.link ] [ text reminder.title ] ]
            , td [] [ a [ onClick ToggleRelativeDate ] [ text (when reminder) ] ]
            ]
      in
        div [ id "reminders" ]
          [ table [ class "table" ]
              [ thead []
                  [ tr []
                      [ th [ class "reminder-title" ] [ text "Title" ]
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
              [ a [ class "card-footer-item", onClick CreateReminder ]
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
