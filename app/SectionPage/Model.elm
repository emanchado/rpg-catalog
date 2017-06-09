module SectionPage.Model exposing (..)

import CatalogModels exposing (Catalog, CatalogItem)


type alias SectionPage =
  { catalog : Maybe Catalog
  , highlightedTag : Maybe String
  , highlightedItem : Maybe CatalogItem
  , tagFilter : List String
  }


init : Maybe Catalog -> SectionPage
init catalog =
  SectionPage catalog Nothing Nothing []
