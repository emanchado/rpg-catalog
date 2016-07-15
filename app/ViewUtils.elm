module ViewUtils exposing (..)

import Html exposing (Html, div, span, li, input, text, img)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import Dict

-- import Models exposing (..)
import Actions exposing (..)
import CatalogModels exposing (..)

-- coverImage : { a | coverImage : CoverImage } -> String -> String -> Html a
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

-- errorView : String -> Html a
errorView errorMessage =
  div [ class "error-message" ]
    [ text errorMessage ]

-- smallItemView : String -> CatalogItem -> (CatalogItemId -> a) -> Html a
smallItemView extraClasses actionFunction item =
    li [ class extraClasses ]
      [ div [ class "item-container", onClick (actionFunction item.id) ]
          [ coverImage item "128x128" "/images/default-item.png"
          , text item.name
          , div [ class "item-description" ] [ text item.description ]
          ]
      ]
