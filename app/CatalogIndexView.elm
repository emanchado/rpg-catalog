module CatalogIndexView exposing (view)

import Dict
import Html exposing (Html, div, span, input, text, img)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)

-- import Models exposing (..)
import Actions exposing (..)
import CatalogModels exposing (..)

coverImage : { a | coverImage : CoverImage } -> String -> String -> Html Msg
coverImage element thumbnailSize defaultImage =
  let imageUrl
        = case element.coverImage of
            Just imageData ->
              case (Dict.get thumbnailSize imageData) of
                Just data ->
                  "/catalog/" ++ data
                Nothing ->
                  defaultImage
            Nothing ->
              defaultImage
  in
    img [ src imageUrl ] []

highlightedItemView : CatalogItem -> Html Msg
highlightedItemView item =
  div [ class "highlighted-item", onClick (ShowItem item.id) ]
    [ coverImage item "64x64" "/images/default-item.png"
    , span [ class "highlighted-item-text" ] [ text item.name ]
    ]

catalogSectionView : CatalogSection -> Html Msg
catalogSectionView section =
  div [ class "section-preview-container" ]
    [ div [ class "section-name", onClick (ShowSection section.id) ] [ text section.name ]
    , div [ class "section-preview" ]
        [ div [ class "section-badge", onClick (ShowSection section.id) ]
            [ coverImage section "128x128" "/images/default-section.png" ]
        , div [ class "highlighted-items" ]
                (List.map highlightedItemView section.items)
        ]
    ]

view : Catalog -> Html Msg
view catalog =
  div []
    (List.map
         (\section -> catalogSectionView section)
         catalog.sections)
