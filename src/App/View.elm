module App.View exposing (..)

import RemoteData exposing (RemoteData(..))
import Date
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
            , div [ class "nav-center" ]
              [ a [ class "nav-item", href "https://github.com/prasmussen/reminders" ]
                [ i [ class "fa fa-github" ] [] ]
              ]
            , span [ class "nav-toggle", classList [ ("is-active", model.showRightMenuOnMobile) ], onClick ToggleRightMenuOnMobile ]
                [ span [] [] , span [] [] , span [] [] ]
            , div [ class "nav-right nav-menu", classList [ ("is-active", model.showRightMenuOnMobile) ] ]
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
      div []
        [ p [] [ text "After signing in with your google account you will be able to easily create reminders in you google calendar by entering text into a text field. The title and time is extracted from the text using a natural language date parser. You will receive an email at the time of the reminder. A list of upcoming reminders is also shown." ]
        , p [] [ text "This web app is 100% client side and the source is available on ", a [ href "https://github.com/prasmussen/reminders" ] [ text "github."] ]
        ]
  in
    [ renderSection "Welcome to Reminders" content ]

authUserContent model =
  [ renderSection "New reminder" (renderCompose model)
  , hr [ class "is-marginless"] []
  , renderSection "Upcoming reminders" (renderReminders model)
  ]

renderCompose model =
  case (Maybe.map validateDraft model.draft) of
    Just (Ok draft) ->
      Html.form [ onSubmit CreateReminder ]
        [ div [ class "field" ]
          [ p [ class "control has-icons-right" ]
            [ input [ class "input is-large is-success", placeholder "buy milk on monday 18:00", type_ "text", required True, autofocus True, onInput SetQuery, value model.query ] []
            , span [ class "icon is-small is-right" ] [ i [class "fa fa-check"] [] ]
            ]
          , renderDraftOrCreateError draft model.createReminderError
          ]
        ]
    Just (Err error) ->
      Html.form []
        [ div [ class "field" ]
          [ p [ class "control has-icons-right" ]
            [ input [ class "input is-large is-danger", placeholder "buy milk on monday 18:00", type_ "text", required True, autofocus True, onInput SetQuery, value model.query ] []
            , span [ class "icon is-small is-right" ] [ i [class "fa fa-warning"] [] ]
            ]
          , p [ class "help is-danger"] [ text error ]
          ]
        ]
    Nothing ->
      case model.query of
        "" ->
          Html.form []
            [ div [ class "field" ]
              [ p [ class "control" ]
                [ input [ class "input is-large", placeholder "buy milk on monday 18:00", type_ "text", required True, autofocus True, onInput SetQuery, value model.query ] []
                ]
              ]
            ]
        _ ->
          Html.form []
            [ div [ class "field" ]
              [ p [ class "control has-icons-right" ]
                [ input [ class "input is-large", placeholder "buy milk on monday 18:00", type_ "text", required True, autofocus True, onInput SetQuery, value model.query ] []
                , span [ class "icon is-small is-right" ] [ i [class "fa fa-warning"] [] ]
                ]
              ]
            ]

renderDraftOrCreateError draft createError =
  case createError of
    Just error ->
      div [ class "notification is-danger" ]
        [ button [ class "delete", type_ "button", onClick ResetCreateReminderError ] []
        , text ("Failed to create reminder: " ++ error)
        ]
    Nothing ->
      div [ class "card" ]
        [ div [ class "card-content" ]
          [ div [ class "content" ]
            [ text draft.title
            , br [] []
            , small [] [ text draft.start ]
            ]
          ]
        , footer [ class "card-footer" ]
          [ a [ class "card-footer-item", onClick CreateReminder ]
            [ text "Create Reminder" ]
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
            [ td [] [ a [ href reminder.link, target "_blank" ] [ text reminder.title ] ]
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

renderSection title content =
  section [ class "section" ]
      [ div [ class "container" ]
          [ div [ class "heading" ]
              [ h1 [ class "title" ] [ text title ]
              ]
          , content
          ]
      ]
