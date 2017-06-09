module Messages exposing (..)

import Http
import Navigation

import CatalogModels exposing (Catalog)
import SectionPage.Messages


type Msg
  = UpdateLocation Navigation.Location
  | CatalogFetch (Result Http.Error Catalog)
  | ShowCatalog
  | ShowSection Int
  | ShowItem Int
  | SectionPage SectionPage.Messages.Msg
