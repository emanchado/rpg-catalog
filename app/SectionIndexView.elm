module SectionIndexView exposing (view)

import Html exposing (Html, nav, h2, div, span, aside, ul, li, a, input, text, img)
import Html.Attributes exposing (src, href, class)
import Html.Events exposing (onClick, onMouseEnter, onMouseLeave)
import String

import Models exposing (..)
import ModelUtils
import Actions exposing (..)
import ViewUtils

tagView : InterfaceProperties -> String -> Html Msg
tagView uiState tag =
  let
    extraClass =
      if List.member tag uiState.tagFilter then
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

tagListView : InterfaceProperties -> CatalogSection -> Html Msg
tagListView uiState section =
  aside [ class "tag-sidebar" ]
    ((h2 [] [ text "Tags" ]) ::
       (List.map (tagView uiState)
          (ModelUtils.getSectionTags section)))

itemView : InterfaceProperties -> CatalogItem -> Html Msg
itemView uiState item =
  let
    itemInFilter =
      (List.isEmpty uiState.tagFilter) ||
        List.all (\t -> List.member t item.tags) uiState.tagFilter

    filterClass =
      if itemInFilter then "" else "filtered-out"

    highlightClass =
      case uiState.highlightedTag of
        Just highlightedTag ->
          if List.member highlightedTag item.tags then "highlighted" else ""
        Nothing ->
          ""
  in
    ViewUtils.smallItemView
      (String.join " " [filterClass, highlightClass])
      item

sectionView : InterfaceProperties -> CatalogSection -> Html Msg
sectionView uiState section =
  div []
    [ nav []
        [ a [ href "#/", onClick ShowCatalog ] [ text "Home" ]
        , text " ⇢ "
        , text section.name
        ]
    , tagListView uiState section
    , ul [ class "item-list" ]
        (List.map (itemView uiState) section.items)
    ]
        
view : CatalogData -> InterfaceProperties -> Int -> Html Msg
view catalog uiState sectionId =
  case ModelUtils.getSection catalog sectionId of
    Just section ->
      sectionView uiState section
    Nothing ->
      ViewUtils.errorView ("Section " ++ (toString sectionId) ++ " does not exist")
