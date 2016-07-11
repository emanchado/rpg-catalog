module SectionIndexView exposing (view)

import Dict
import Html exposing (Html, h2, div, span, aside, ul, li, input, text, img)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)

import Models exposing (..)
import ModelUtils
import Actions exposing (..)
import ViewUtils

itemView : CatalogItem -> Html Msg
itemView item =
  li [ ]
    [ div [ class "item-container", onClick (ShowItem item.id) ]
        [ ViewUtils.coverImage item "128x128" "/images/default-item.png"
        , text item.name
        ]
    ]

tagListView : CatalogSection -> Html Msg
tagListView section =
  aside [ class "tag-sidebar" ]
    (List.map (\t -> div [ class "tag" ] [ text ("#" ++ t) ])
       (ModelUtils.getSectionTags section))

sectionView : CatalogSection -> Html Msg
sectionView section =
  div []
    [ h2 [] [ text section.name ]
    , tagListView section
    , ul [ class "item-list" ]
        (List.map (\i -> itemView i) section.items)
    ]
        
view : CatalogData -> Int -> Html Msg
view catalog sectionId =
  case ModelUtils.getSection catalog sectionId of
    Just section ->
      sectionView section
    Nothing ->
      ViewUtils.errorView ("Section " ++ (toString sectionId) ++ " does not exist")
