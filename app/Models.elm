module Models exposing (..)

import Routing
import SectionPage.Model exposing (..)
import CatalogModels exposing (Catalog)

type alias Model =
  { route : Routing.Route
  , catalogUrl : String
  , catalog : Maybe Catalog
  , sectionPage : SectionPage
  }
