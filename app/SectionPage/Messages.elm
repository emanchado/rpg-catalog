module SectionPage.Messages exposing (..)

import SectionPage.Model exposing (SectionPage)

type Msg
  = HighlightTag String
  | UnhighlightTag
  | ToggleTagFilter String
  | ShowItem Int
