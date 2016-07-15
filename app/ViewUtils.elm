module ViewUtils exposing (..)

import Html exposing (Html, div, span, li, input, text, img)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import Dict

import CatalogModels exposing (..)

coverImage : { a | coverImage : CoverImage } -> String -> String -> Html msg
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

errorView : String -> Html msg
errorView errorMessage =
  div [ class "error-message" ]
    [ text errorMessage ]

smallItemView : String -> (CatalogItemId -> a) -> List (Html.Attribute a) -> CatalogItem -> Html a
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
          , text item.name
          , div [ class "item-description" ] [ text item.description ]
          ]
      ]
