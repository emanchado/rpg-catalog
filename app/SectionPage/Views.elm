module SectionPage.Views exposing (view)

import Html exposing (Html, nav, h2, div, span, aside, ul, li, a, input, text, img)
import Html.Attributes exposing (src, href, class)
import Html.Events exposing (onClick, onMouseEnter, onMouseLeave)
import String

import ModelUtils
import SectionPage.Messages exposing (Msg(..))
import ViewUtils
import CatalogModels exposing (..)
import SectionPage.Model exposing (SectionPage)

tagView : SectionPage -> String -> Html Msg
tagView sectionPage tag =
  let
    extraClass =
      if List.member tag sectionPage.tagFilter then
        " highlighted"
      else
        ""
  in
    a [ class ("tag" ++ extraClass)
      -- , href ("#/section/" ++ "3" ++ "/tags/" ++ tag)
      , onMouseEnter (HighlightTag tag)
      , onMouseLeave UnhighlightTag
      , onClick (ToggleTagFilter tag)
      ]
      [ text tag ]

tagListView : SectionPage -> CatalogSection -> Html Msg
tagListView sectionPage section =
  aside [ class "tag-sidebar" ]
    ((h2 [] [ text "Tags" ]) ::
       (List.map (tagView sectionPage)
          (ModelUtils.getSectionTags section)))

itemView : SectionPage -> CatalogItem -> Html Msg
itemView sectionPage item =
  let
    itemInFilter =
      (List.isEmpty sectionPage.tagFilter) ||
        List.all (\t -> List.member t item.tags) sectionPage.tagFilter

    filterClass =
      if itemInFilter then "" else "filtered-out"

    highlightClass =
      case sectionPage.highlightedTag of
        Just highlightedTag ->
          if List.member highlightedTag item.tags then "highlighted" else ""
        Nothing ->
          ""
  in
    ViewUtils.smallItemView
      (String.join " " [filterClass, highlightClass])
      (\id -> ShowItem id)
      item

sectionView : SectionPage -> CatalogSection -> Html Msg
sectionView sectionPage section =
  div []
    [ nav []
        [ a [ href "#/" ] [ text "Home" ]
        , text " ⇢ "
        , text section.name
        ]
    , tagListView sectionPage section
    , ul [ class "item-list" ]
        (List.map (itemView sectionPage) section.items)
    ]

view : Catalog -> SectionPage -> Int -> Html Msg
view catalog sectionPage sectionId =
  case ModelUtils.getSection catalog sectionId of
    Just section ->
      sectionView sectionPage section
    Nothing ->
      ViewUtils.errorView ("Section " ++ (toString sectionId) ++ " does not exist")
