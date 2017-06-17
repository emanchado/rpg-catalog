module Messages exposing (..)

import Http
import Navigation
import Json.Decode

import CatalogModels exposing (Catalog)
import SectionPage.Messages


type Msg
  = UpdateLocation Navigation.Location
  | CatalogFetch (Result Http.Error Catalog)
  | UpdateSearchTerms String
  | GoToSearch
  | PerformSearch String
  | ShowCatalog
  | ShowSection Int
  | ShowItem Int
  | SectionPage SectionPage.Messages.Msg
  | IndexCatalogSuccess Json.Decode.Value
