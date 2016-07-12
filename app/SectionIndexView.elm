module SectionIndexView exposing (view)

import String
import Html exposing (Html, h2, h3, div, span, aside, ul, li, a, input, text, img)
import Html.Attributes exposing (src, href, class)
import Html.Events exposing (onClick, onMouseEnter, onMouseLeave)

import Models exposing (..)
import ModelUtils
import Actions exposing (..)
import ViewUtils

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
    li [ class (String.join " " [filterClass, highlightClass]) ]
      [ div [ class "item-container", onClick (ShowItem item.id) ]
          [ ViewUtils.coverImage item "128x128" "/images/default-item.png"
          , text item.name
          , div [ class "item-description" ] [ text item.description ]
          ]
      ]

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
    ((h3 [] [ text "Tags" ]) ::
       (List.map (\t -> tagView uiState t)
          (ModelUtils.getSectionTags section)))

sectionView : InterfaceProperties -> CatalogSection -> Html Msg
sectionView uiState section =
  div []
    [ h2 []
        [ a [ href "/", onClick ShowCatalog ] [ text "Home" ]
        , text " ⇢ "
        , text section.name
        ]
    , tagListView uiState section
    , ul [ class "item-list" ]
        (List.map (\i -> itemView uiState i) section.items)
    ]
        
view : CatalogData -> InterfaceProperties -> Int -> Html Msg
view catalog uiState sectionId =
  case ModelUtils.getSection catalog sectionId of
    Just section ->
      sectionView uiState section
    Nothing ->
      ViewUtils.errorView ("Section " ++ (toString sectionId) ++ " does not exist")
