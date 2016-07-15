module Messages exposing (..)

import Http

import CatalogModels exposing (Catalog)
import SectionPage.Messages

type Msg
  = CatalogFetchError Http.Error
  | CatalogFetchSucceeded Catalog
  | ShowCatalog
  | ShowSection Int
  | ShowItem Int
  | SectionPage SectionPage.Messages.Msg
