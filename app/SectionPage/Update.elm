module SectionPage.Update exposing (..)

import SectionPage.Messages exposing (Msg(..))
import SectionPage.Model exposing (SectionPage)
import NavigationUtils exposing (showItemCmd)

update : Msg -> SectionPage -> (SectionPage, Cmd Msg)
update msg model =
  case msg of
    HighlightTag tag ->
      ({ model | highlightedTag = Just tag }, Cmd.none)

    UnhighlightTag ->
      ({ model | highlightedTag = Nothing }, Cmd.none)

    ToggleTagFilter tag ->
      let
        toggleTag tag list =
          if List.member tag list then
            List.filter (\t -> t /= tag) list
          else
            tag :: list
      in
        ({ model | tagFilter = toggleTag tag model.tagFilter }, Cmd.none)

    HighlightItemTags item ->
      ({ model | highlightedItem = Just item }, Cmd.none)

    UnhighlightItemTags ->
      ({ model | highlightedItem = Nothing }, Cmd.none)

    ShowItem itemId ->
      (model, showItemCmd itemId)
