module SectionPage.Model exposing (..)

import CatalogModels exposing (Catalog)

type alias SectionPage =
  { catalog : Maybe Catalog
  , highlightedTag : Maybe String
  , tagFilter : List String
  }

init : Maybe Catalog -> SectionPage
init catalog =
  SectionPage catalog Nothing []
