module Models exposing (..)

import Dict exposing (Dict)

import Routing
import SectionPage.Model exposing (..)
import CatalogModels exposing (Catalog, CatalogSection, CatalogItem)


type CatalogResult
  = ResultSection CatalogSection
  | ResultItem CatalogItem

type alias SearchIndex = Dict String (List CatalogResult)


type alias Model =
  { route : Routing.Route
  , catalogUrl : String
  , catalog : Maybe Catalog
  , sectionPage : SectionPage
  , searchTerms : String
  , searchIndex : Maybe SearchIndex
  }
