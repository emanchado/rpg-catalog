module Views exposing (mainApplicationView)

import Html exposing (Html, div, span, input, text, img)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)

import Routing
import Models exposing (Model)
import Actions exposing (Msg)
import CatalogIndexViews

mainApplicationView : Model -> Html Msg
mainApplicationView model =
  case model.catalogData of
    Just data ->
      case model.route of
        Routing.CatalogIndex ->
          CatalogIndexViews.view data
        Routing.SectionIndex sectionId ->
          div []
            [ text ("Here I'll show section " ++ (toString sectionId))
            ]
        Routing.ItemDetail itemId ->
          div []
            [ text ("Here I'll show item " ++ (toString itemId))
            ]
        Routing.NotFoundRoute ->
          div []
            [ text "404 Not Found"
            ]
    Nothing ->
      div [] [ text "Loading…" ]
