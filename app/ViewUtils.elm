module ViewUtils exposing (..)

import Html exposing (Html, div, span, li, input, text, img)
import Html.Attributes exposing (src, height, width, class, title)
import Html.Events exposing (onClick)
import Dict

import CatalogModels exposing (..)

coverImage : { a | coverImage : CoverImage } -> String -> String -> Html msg
coverImage element thumbnailSize defaultImage =
  let
    imageUrl = case element.coverImage of
                 Just imageData ->
                   case (Dict.get thumbnailSize imageData) of
                     Just data -> "/catalog/" ++ data
                     Nothing -> defaultImage
                 Nothing ->
                   defaultImage
    xIndex = String.indexes "x" thumbnailSize
    sideLength = case (List.head xIndex) of
                   Just index ->
                     case (String.toInt <| String.slice 0 index thumbnailSize) of
                       Ok result -> result
                       _ -> 512
                   Nothing ->
                     512
  in
    img [ src imageUrl
        , width sideLength
        , height sideLength
        ]
      []

errorView : String -> Html msg
errorView errorMessage =
  div [ class "error-message" ]
    [ text errorMessage ]

smallItemView : String -> (CatalogItemId -> msg) -> List (Html.Attribute msg) -> CatalogItem -> Html msg
smallItemView extraClasses actionFunction extraAttributes item =
  let
    itemContainerAttributes =
      List.concat
        [ [ class "item-container", onClick (actionFunction item.id) ]
        , extraAttributes
        ]
  in
    li [ class extraClasses ]
      [ div itemContainerAttributes
          [ coverImage item "128x128" "/images/default-item.png"
          , div [ class "item-name", title item.name ] [ text item.name ]
          , div [ class "item-description" ] [ text item.description ]
          ]
      ]
