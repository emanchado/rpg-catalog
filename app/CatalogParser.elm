module CatalogParser exposing (parseCatalog)

import Json.Decode as Json exposing (..)
import CatalogModels exposing (..)


decodeItem : Json.Decoder CatalogItem
decodeItem =
    Json.map6
      CatalogItem
      (field "id" int)
      (field "name" string)
      (field "description" string)
      (field "tags" <| list string)
      (maybe (field "url" string))
      (maybe (field "coverImage" (dict string)))


decodeSection : Json.Decoder CatalogSection
decodeSection =
    Json.map5
      CatalogSection
      (field "id" int)
      (field "name" string)
      (field "description" string)
      (field "items" <| list decodeItem)
      (maybe (field "coverImage" <| dict string))


parseCatalog : Json.Decoder Catalog
parseCatalog =
    Json.map3
      Catalog
      (field "name" string)
      (field "thumbnailSizes" <| list string)
      (field "sections" <| list decodeSection)
