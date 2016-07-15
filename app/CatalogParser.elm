module CatalogParser exposing (parseCatalog)

import Json.Decode as Json exposing (..)

import CatalogModels exposing (..)

decodeItem : Json.Decoder CatalogItem
decodeItem =
  Json.object6 CatalogItem ("id" := int) ("name" := string) ("description" := string) ("tags" := list string) (maybe ("url" := string)) (maybe ("coverImage" := (dict string)))

decodeSection : Json.Decoder CatalogSection
decodeSection =
  Json.object4 CatalogSection ("id" := int) ("name" := string) ("items" := list decodeItem) (maybe ("coverImage" := (dict string)))

parseCatalog : Json.Decoder Catalog
parseCatalog =
  Json.object3 Catalog ("name" := string) ("thumbnailSizes" := list string) ("sections" := list decodeSection)
