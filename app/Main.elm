import Http
import Task
import Navigation

import Routing
import Messages exposing (..)
import Update
import Models exposing (..)
import Views
import CatalogParser exposing (parseCatalog)
import SectionPage.Model

main : Program Never
main =
  Navigation.program Routing.parser
    { init = init
    , view = Views.mainApplicationView
    , update = Update.update
    , urlUpdate = Update.urlUpdate
    , subscriptions = subscriptions
    }

init : Result String Routing.Route -> (Model, Cmd Msg)
init result =
  let
    catalogJsonUrl = "catalog/catalog.json"
    currentRoute = Routing.routeFromResult result
  in
    (Model currentRoute catalogJsonUrl Nothing (SectionPage.Model.init Nothing), getCatalog catalogJsonUrl)

getCatalog : String -> Cmd Msg
getCatalog catalogUrl =
  Task.perform CatalogFetchError CatalogFetchSucceeded (Http.get parseCatalog (catalogUrl))

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
