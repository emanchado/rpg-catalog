module Main exposing (..)

import Http
import Navigation
import Routing
import Messages exposing (..)
import Update
import Models exposing (..)
import Views
import CatalogParser exposing (parseCatalog)
import SectionPage.Model
import Ports exposing (indexCatalogSuccess)


main : Program Never Model Msg
main =
  Navigation.program UpdateLocation
    { init = init
    , view = Views.mainApplicationView
    , update = Update.update
    , subscriptions = subscriptions
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
  let
    catalogJsonUrl = "catalog/catalog.json"
  in
    ( { route = Routing.parseLocation location
      , catalogUrl = catalogJsonUrl
      , catalog = Nothing
      , sectionPage = SectionPage.Model.init Nothing
      , searchTerms = ""
      , searchIndex = Nothing
      }
    , getCatalog catalogJsonUrl
    )


getCatalog : String -> Cmd Msg
getCatalog catalogUrl =
  Http.send CatalogFetch <|
    Http.get catalogUrl parseCatalog


subscriptions : Model -> Sub Msg
subscriptions model =
  indexCatalogSuccess IndexCatalogSuccess
