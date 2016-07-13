module ViewUtils exposing (..)

import Html exposing (Html, div, span, li, input, text, img)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import Dict

import Models exposing (..)
import Actions exposing (..)

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

errorView : String -> Html Msg
errorView errorMessage =
  div [ class "error-message" ]
    [ text errorMessage ]

smallItemView : String -> CatalogItem -> Html Msg
smallItemView extraClasses item =
    li [ class extraClasses ]
      [ div [ class "item-container", onClick (ShowItem item.id) ]
          [ coverImage item "128x128" "/images/default-item.png"
          , text item.name
          , div [ class "item-description" ] [ text item.description ]
          ]
      ]
