module NavigationUtils exposing (..)

import Navigation

import CatalogModels exposing (CatalogSectionId, CatalogItemId)

-- showItemCmd : CatalogItemId -> Cmd Msg
showItemCmd itemId =
  Navigation.modifyUrl ("#item/" ++ (toString itemId))
