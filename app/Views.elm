module Views exposing (mainApplicationView)

import Html exposing (Html, div, span, a, input, text, img)
import Html.App
import Html.Attributes exposing (class, src, href)
import Html.Events exposing (onClick)

import Routing
import Models exposing (Model)
import Actions exposing (..)
import CatalogIndexView
import SectionPage.Views
import ItemDetailView

notFoundView : Model -> Html Msg
notFoundView model =
  div []
    [ div [] [ text "404 Not Found" ]
    , a [ href "#/", onClick ShowCatalog ] [ text "Back to homepage" ]
    ]

loadingView : Model -> Html Msg
loadingView model =
  div [] [ text "Loading…" ]

mainApplicationView : Model -> Html Msg
mainApplicationView model =
  case model.catalog of
    Just data ->
      case model.route of
        Routing.CatalogIndex ->
          CatalogIndexView.view data
        Routing.SectionIndex sectionId ->
          Html.App.map SectionPage (SectionPage.Views.view data model.sectionPage sectionId)
        Routing.ItemDetail itemId ->
          ItemDetailView.view data itemId
        Routing.NotFoundRoute ->
          notFoundView model
    Nothing ->
      loadingView model
