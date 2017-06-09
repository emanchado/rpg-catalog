module NavigationUtils exposing (..)

import Navigation
import CatalogModels exposing (CatalogItemId)


showItemCmd : CatalogItemId -> Cmd a
showItemCmd itemId =
    Navigation.newUrl ("#item/" ++ (toString itemId))
