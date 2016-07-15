module SectionPage.Messages exposing (..)

import CatalogModels exposing (CatalogItem)

type Msg
  = HighlightTag String
  | UnhighlightTag
  | ToggleTagFilter String
  | HighlightItemTags CatalogItem
  | UnhighlightItemTags
  | ShowItem Int
